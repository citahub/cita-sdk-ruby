# frozen_string_literal: true
require "active_support/core_ext/string"

module CITA
  class Transaction
    class VersionError < StandardError
    end

    attr_accessor :to, :nonce, :quota, :valid_until_block, :data, :value, :chain_id, :version

    # @param nonce [String] default is SecureRandom.hex; if you provide with nil or empty string, it will be assigned a random string.
    # @param valid_until_block [Integer]
    # @param chain_id [Integer | String] hex string if version == 1
    # @param version [Integer]
    # @param to [String]
    # @param data [String]
    # @param value: [String | Integer] hex string or decimal integer
    # @param quota [Integer]
    #
    # @return [void]
    def initialize(valid_until_block:, chain_id:, nonce: nil, version: 1, to: nil, data: nil, value: "2", quota: 1_000_000) # rubocop:disable Metrics/ParameterLists
      raise VersionError, "transaction version error, expected 0, 1 or 2, got #{version}" unless [0, 1, 2].include?(version)

      @to = to
      @nonce = nonce.blank? ? SecureRandom.hex : nonce
      @quota = quota
      @valid_until_block = valid_until_block
      @data = data
      @chain_id = if chain_id.is_a?(String)
                    chain_id.delete("-")
                  else
                    chain_id
                  end
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
        version: h[:version] || 1,
        value: h[:value] || "0",
        quota: h[:quota] || 1_000_000
      )
    end
  end
end
