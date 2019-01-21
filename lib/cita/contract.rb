# frozen_string_literal: true

require "web3/eth"

module CITA
  class Contract
    include Web3::Eth::Abi::AbiCoder

    attr_reader :url, :abi, :address, :rpc

    # @param abi [String | Hash] json string or hash
    # @param url [String] chain url
    # @param address [String] contract address
    # @param rpc [CITA::RPC]
    #
    # @return [void]
    def initialize(abi, url, address = nil, rpc = nil)
      @url = url
      @abi = abi
      @address = address
      @rpc = rpc
      parse_url
    end

    # wrapper Web3::Eth abi encoder for encoded data
    #
    # @param method_name [Symbol | String] method name you call
    # @param *params [Array] method params you call
    #
    # @return [String] hex data
    def function_data(method_name, *params)
      data, _output_types = function_data_with_ot(method_name, *params)
      data
    end

    # call contract functions by rpc `call` method
    #
    # @param method [Symbol | String] the method name you call
    # @param params [Array] the method params you call
    # @param tx [Hash] see rpc `call` doc for more info
    #
    # @return [any]
    def call_func(method:, params: [], tx: {}) # rubocop:disable Naming/UncommunicativeMethodParamName
      data, output_types = function_data_with_ot(method, *params)
      resp = @rpc.call_rpc(:call, params: [tx.merge(data: data, to: address), "latest"])
      result = resp["result"]

      data = [Utils.remove_hex_prefix(result)].pack("H*")
      return if data.nil?

      re = decode_abi output_types, data
      re.length == 1 ? re.first : re
    end

    # call contract functions by sendRawTransaction
    #
    # @param tx [Hash | CITA::Transaction]
    # @param private_key [String] hex string
    # @param method [Symbol | String] method name you call
    # @param *params [Array] your params
    #
    # @return [nil | Hash] {hash: "", status: ""}, sendRawTransactionResult
    def send_func(tx:, private_key:, method:, params: []) # rubocop:disable Naming/UncommunicativeMethodParamName
      data, _output_types = function_data_with_ot(method, *params)
      transaction = if tx.is_a?(Hash)
                      Transaction.from_hash(tx)
                    else
                      tx
                    end
      transaction.data = data
      resp = @rpc.send_transaction(transaction, private_key)

      resp&.dig("result")
    end

    private

    # parse url to host, port and scheme
    def parse_url
      uri = URI.parse(@url)
      @host = uri.host
      @port = uri.port
      @scheme = uri.scheme
    end

    # is this url in https?
    def https?
      @scheme == "https"
    end

    # wrapper Web3::Eth abi encoder for encoded data
    def function_data_with_ot(method_name, *params)
      web3 = Web3::Eth::Rpc.new host: @host, port: @port, connect_options: { use_ssl: https? }
      contract = web3.eth.contract(abi).at(address)
      contract.function_data(method_name, *params)
    end
  end
end
