# frozen_string_literal: true

module AppChain
  class Transaction
    attr_accessor :to, :nonce, :quota, :valid_until_block, :data, :value, :chain_id, :version

    # @param nonce [String]
    # @param valid_until_block [Integer]
    # @param chain_id [Integer]
    # @param version [Integer]
    # @param to [String]
    # @param data [String]
    # @param value: [String | Integer] hex string or decimal integer
    # @param quota [Integer]
    #
    # @return [void]
    def initialize(nonce:, valid_until_block:, chain_id:, version: 0, to: nil, data: nil, value: "0", quota: 1_000_000)
      @to = to
      @nonce = nonce
      @quota = quota
      @valid_until_block = valid_until_block
      @data = data
      @chain_id = chain_id
      @version = version
      @value = if value.is_a?(Integer)
                 Utils.to_hex(value)
               else
                 value
               end
    end

    def self.from_hash(hash)
      h = hash.map { |k, v| { k.to_sym => v } }.reduce({}, :merge)

      new(
        nonce: h[:nonce],
        valid_until_block: h[:valid_until_block],
        chain_id: h[:chain_id],
        to: h[:to],
        data: h[:data],
        version: h[:version] || 0,
        value: h[:value] || "0",
        quota: h[:quota] || 1_000_000
      )
    end
  end
end
