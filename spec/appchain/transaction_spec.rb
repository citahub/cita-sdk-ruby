RSpec.describe AppChain::Transaction do
  let(:valid_until_block) { 88 }
  let(:chain_id) { "1" }

  context "nonce" do
    it "get random string if nonce is nil" do
      transaction = AppChain::Transaction.new(valid_until_block: valid_until_block, chain_id: chain_id, nonce: nil)
      expect(transaction.nonce.size).to eq 32
    end

    it "get random string if nonce is empty string" do
      transaction = AppChain::Transaction.new(valid_until_block: valid_until_block, chain_id: chain_id, nonce: "")
      expect(transaction.nonce.size).to eq 32
    end

    it "get itself if nonce not blank" do
      nonce = SecureRandom.hex
      transaction = AppChain::Transaction.new(valid_until_block: valid_until_block, chain_id: chain_id, nonce: nonce)
      expect(transaction.nonce).to eq nonce
    end
  end
end
