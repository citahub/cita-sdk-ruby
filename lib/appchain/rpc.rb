# frozen_string_literal: true
require "active_support/inflector"

module AppChain
  class RPC
    attr_reader :url, :http

    # CITA v0.18 RPC list
    METHOD_NAMES = %w(
      peerCount
      blockNumber
      sendRawTransaction
      getBlockByHash
      getBlockByNumber
      getTransaction
      getTransactionReceipt
      getLogs
      call
      getTransactionCount
      getCode
      getAbi
      getBalance
      newFilter
      newBlockFilter
      uninstallFilter
      getFilterChanges
      getFilterLogs
      getTransactionProof
      getMetaData
      getBlockHeader
      getStateProof
    ).freeze

    def initialize(url)
      @url = url
      @http = Http.new(@url)
    end

    # generate rpc methods
    METHOD_NAMES.each do |name|
      define_method name do |*params|
        call_rpc(name, params: params)
      end

      define_method name.underscore do |*params|
        send(name, *params)
      end
    end

    # @return [Hash] response body
    def call_rpc(method, jsonrpc: Http::DEFAULT_JSONRPC, params: Http::DEFAULT_PARAMS, id: Http::DEFAULT_ID)
      resp = http.call_rpc(method, params: params, jsonrpc: jsonrpc, id: id)
      JSON.parse(resp.body)
    end

    # @param transaction [AppChain::Transaction]
    # @return [Hash]
    def send_transaction(transaction, private_key)
      content = TransactionSigner.encode(transaction, private_key)
      send_raw_transaction(content)
    end

    # easy to transfer tokens
    #
    # @param to [String] to address
    # @param private_key [String]
    # @param value [String | Integer] hex string or decimal integer
    # @param quota [Integer] default to 30_000
    #
    # @return [Hash]
    def transfer(to:, private_key:, value:, quota: 30_000)
      valid_until_block = block_number["result"].hex + 88
      chain_id = get_meta_data("latest").dig "result", "chainId"
      transaction = Transaction.new(nonce: Utils.nonce, valid_until_block: valid_until_block, chain_id: chain_id, to: to, value: value, quota: quota)
      send_transaction(transaction, private_key)
    end
  end
end
