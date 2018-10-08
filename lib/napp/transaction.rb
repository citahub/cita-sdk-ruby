# frozen_string_literal: true

module NApp
  class Transaction
    attr_accessor :to, :nonce, :quota, :valid_until_block, :data, :value, :chain_id, :version

    # @param nonce [String]
    # @param valid_until_block [Integer]
    # @param chain_id [Integer]
    # @param version [Integer]
    # @param to [String]
    # @param data [String]
    # @param value: [String] hex string
    # @param quota [Integer]
    #
    # @return [void]
    def initialize(nonce:, valid_until_block:, chain_id:, version: 0, to: nil, data: nil, value: "0", quota: 1_000_000)
      @to = to
      @nonce = nonce
      @quota = quota
      @valid_until_block = valid_until_block
      @data = data
      @value = value
      @chain_id = chain_id
      @version = version
    end
  end
end
