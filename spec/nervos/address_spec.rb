RSpec.describe Nervos::Address do
  let(:addr) { "0x8ff0f5b85fba9a6429e2e256880291774f8e224f" }

  context "==" do
    it "same lower case" do
      expect(Nervos::Address.new(addr)).to eq Nervos::Address.new(addr)
    end

    it "ignore case" do
      expect(Nervos::Address.new(addr)).to eq Nervos::Address.new(addr.upcase)
    end
  end
end
