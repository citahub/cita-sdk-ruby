# frozen_string_literal: true

module NApp
  class Client
    attr_reader :url, :rpc, :http

    def initialize(url)
      @url = url
      @rpc = RPC.new(url)
      @http = rpc.http
    end
  end
end
