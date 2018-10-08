# frozen_string_literal: true
require "active_support/inflector"

module NApp
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
  end
end
