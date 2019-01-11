# frozen_string_literal: true

module CITA
  class Client
    attr_reader :url, :rpc, :http, :contract

    def initialize(url)
      @url = url
      @rpc = RPC.new(url)
      @http = rpc.http
    end

    def contract_at(abi, address)
      @contract = Contract.new(abi, url, address, rpc)
    end
  end
end
