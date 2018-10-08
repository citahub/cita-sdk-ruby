require "ciri/utils"
require "ciri/crypto"

module NApp
  class TransactionSigner
    class << self
      # sign transaction
      #
      # @param transaction [NApp::Transaction]
      # @param private_key [String]
      def encode(transaction, private_key)
        tx = NApp::Protos::Transaction.new

        tx.nonce = transaction.nonce
        to = NApp::Utils.remove_hex_prefix(transaction.to)&.downcase
        tx.to = to unless to.nil?
        tx.quota = transaction.quota
        tx.data = NApp::Utils.to_bytes(transaction.data)
        tx.version = transaction.version
        tx.value = process_value(transaction.value)
        tx.chain_id = transaction.chain_id
        tx.valid_until_block = transaction.valid_until_block

        encoded_tx = Protos::Transaction.encode(tx)

        private_key_bytes = NApp::Utils.to_bytes(private_key)

        protobuf_hash = Utils.keccak256(encoded_tx)

        signature = Ciri::Crypto.ecdsa_signature(private_key_bytes, protobuf_hash).signature

        unverified_tx = Protos::UnverifiedTransaction.new(transaction: tx, signature: signature)

        encoded_unverified_tx = Protos::UnverifiedTransaction.encode(unverified_tx)

        NApp::Utils.from_bytes(encoded_unverified_tx)
      end


      # unsign transaction
      #
      # @param tx_content [String] hex string
      def decode(tx_content)
        content_bytes = NApp::Utils.to_bytes(tx_content)
        unverified_transaction = Protos::UnverifiedTransaction.decode(content_bytes)

        signature = unverified_transaction["signature"]

        transaction = unverified_transaction["transaction"]
        msg = Protos::Transaction.encode(transaction)
        msg_hash = NApp::Utils.keccak256(msg)
        pubkey = Ciri::Crypto.ecdsa_recover(msg_hash, signature)
        pubkey_hex = Utils.from_bytes(pubkey[1..-1])

        from_address = Utils.keccak256(pubkey[1..-1])[-20..-1]
        from_address_hex = Utils.from_bytes(from_address)

        sender = {
          "address" => from_address_hex,
          "public_key" => pubkey_hex
        }

        {
          "unverified_transaction" => unverified_transaction,
          "sender" => sender
        }
      end

      private

      # @param value [String] hex string with or without `0x` prefix
      # @return [String] byte code string
      def process_value(value)
        NApp::Utils.to_bytes(NApp::Utils.remove_hex_prefix(value).rjust(64, '0'))
      end

    end
  end
end
