# frozen_string_literal: true
require "json"
require "faraday"

module CITA
  class Http
    attr_accessor :url

    DEFAULT_JSONRPC = "2.0"
    DEFAULT_PARAMS = [].freeze
    DEFAULT_ID = 83

    def initialize(url)
      @url = url
    end

    # wrapper for call rpc method
    #
    # @param method [String] method you want to call
    # @param jsonrpc [String] jsonrpc version
    # @param params [Array] rpc params
    # @param id [Integer] jsonrpc id
    #
    # @return [Faraday::Response]
    def call_rpc(method, jsonrpc: DEFAULT_JSONRPC, params: DEFAULT_PARAMS, id: DEFAULT_ID)
      conn.post("/", rpc_params(method, jsonrpc: jsonrpc, params: params, id: id))
    end

    # wrapper for rpc params
    #
    # @param method [String] method you want to call
    # @param jsonrpc [String] jsonrpc version
    # @param params [Array] rpc params
    # @param id [Integer] jsonrpc id
    #
    # @return [String] json string
    def rpc_params(method, jsonrpc: DEFAULT_JSONRPC, params: DEFAULT_PARAMS, id: DEFAULT_ID)
      {
        jsonrpc: jsonrpc,
        id: id,
        method: method,
        params: params
      }.to_json
    end

    # wrapper faraday object with CITA URL and Content-Type
    #
    # @return [Faraday]
    def conn
      Faraday.new(url: url) do |faraday|
        faraday.headers["Content-Type"] = "application/json"
        faraday.request  :url_encoded # form-encode POST params
        faraday.adapter  Faraday.default_adapter # make requests with Net::HTTP
      end
    end
  end
end
