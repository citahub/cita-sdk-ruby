require "ciri/utils"
require "ciri/crypto"

module Nervos
  class TransactionSigner
    class << self
      # sign transaction
      #
      # @param transaction [Nervos::Transaction]
      # @param private_key [String]
      def encode(transaction:, private_key:)
        tx = Protos::Transaction.new

        tx.nonce = transaction.nonce
        to = Nervos::Utils.remove_hex_prefix(transaction.to)&.downcase
        tx.to = to unless to.nil?
        tx.quota = transaction.quota
        tx.data = Nervos::Utils.to_bytes(transaction.data)
        tx.version = transaction.version
        tx.value = process_value(transaction.value)
        tx.chain_id = transaction.chain_id
        tx.valid_until_block = transaction.valid_until_block

        encoded_tx = Protos::Transaction.encode(tx)

        private_key_bytes = Nervos::Utils.to_bytes(private_key)

        protobuf_hash = Ciri::Utils.keccak(encoded_tx)

        signature = Ciri::Crypto.ecdsa_signature(private_key_bytes, protobuf_hash).signature

        unverified_tx = Protos::UnverifiedTransaction.new(transaction: tx, signature: signature)

        encoded_unverified_tx = Protos::UnverifiedTransaction.encode(unverified_tx)

        Nervos::Utils.from_bytes(encoded_unverified_tx)
      end

      private

      # @param value [String] hex string with or without `0x` prefix
      # @return [String] byte code string
      def process_value(value)
        Nervos::Utils.to_bytes(Nervos::Utils.remove_hex_prefix(value).rjust(64, '0'))
      end

    end
  end
end
