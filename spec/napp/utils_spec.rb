RSpec.describe NApp::Utils do
  context "add_hex_prefix" do
    it "without prefix" do
      hex = "124"
      expect(NApp::Utils.add_hex_prefix(hex)).to eq "0x#{hex}"
    end

    it "with prefix" do
      hex = "0x124"
      expect(NApp::Utils.add_hex_prefix(hex)).to eq hex
    end
  end

  context "remove_hex_prefix" do
    it "with prefix" do
      hex = "0x124"
      expect(NApp::Utils.remove_hex_prefix(hex)).to eq "124"
    end

    it "without prefix" do
      hex = "124"
      expect(NApp::Utils.remove_hex_prefix(hex)).to eq hex
    end
  end

  context "to_hex" do
    it "correct" do
      decimal = 100
      hex = "64"
      expect(NApp::Utils.to_hex(decimal)).to eq "0x#{hex}"
    end
  end

  context "to_decimal" do
    it "without prefix" do
      hex = "64"
      decimal = 100

      expect(NApp::Utils.to_decimal(hex)).to eq decimal
    end

    it "with prefix" do
      hex = "0x64"
      decimal = 100

      expect(NApp::Utils.to_decimal(hex)).to eq decimal
    end
  end

  context "to_bytes" do
    it "without prefix" do
      str = "0124"
      bytes = [str].pack("H*")

      expect(NApp::Utils.to_bytes(str)).to eq bytes
    end

    it "with prefix" do
      str = "0x0124"
      bytes = ["0124"].pack("H*")

      expect(NApp::Utils.to_bytes(str)).to eq bytes
    end
  end

  context "from_bytes" do
    it "correct" do
      str = "0x0124"
      bytes = NApp::Utils.to_bytes(str)

      expect(NApp::Utils.from_bytes(bytes)).to eq str
    end
  end
end
