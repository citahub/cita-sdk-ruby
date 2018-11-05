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

  context "chain_id" do
    let(:nonce) { "" }

    it "get itself if integer" do
      chain_id = 1
      transaction = AppChain::Transaction.new(valid_until_block: valid_until_block, nonce: nonce, chain_id: chain_id)
      expect(transaction.chain_id).to eq chain_id
    end

    it "get it self if a hex string" do
      chain_id = SecureRandom.hex
      transaction = AppChain::Transaction.new(valid_until_block: valid_until_block, nonce: nonce, chain_id: chain_id)
      expect(transaction.chain_id).to eq chain_id
    end

    it "remove - if exists" do
      chain_id = SecureRandom.uuid
      transaction = AppChain::Transaction.new(valid_until_block: valid_until_block, nonce: nonce, chain_id: chain_id)
      expect(transaction.chain_id).not_to eq chain_id
      expect(transaction.chain_id).to eq chain_id.remove("-")
    end
  end
end
