# frozen_string_literal: true

RSpec.describe NApp::Contract do
  let(:abi_str) do
    "[{\"constant\":true,\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\",\"signature\":\"0x06fdde03\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\",\"signature\":\"0x095ea7b3\"},{\"constant\":true,\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\",\"signature\":\"0x18160ddd\"},{\"constant\":false,\"inputs\":[{\"name\":\"_from\",\"type\":\"address\"},{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\",\"signature\":\"0x23b872dd\"},{\"constant\":true,\"inputs\":[],\"name\":\"decimals\",\"outputs\":[{\"name\":\"\",\"type\":\"uint8\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\",\"signature\":\"0x313ce567\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_subtractedValue\",\"type\":\"uint256\"}],\"name\":\"decreaseApproval\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\",\"signature\":\"0x66188463\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\",\"signature\":\"0x70a08231\"},{\"constant\":true,\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\",\"signature\":\"0x95d89b41\"},{\"constant\":false,\"inputs\":[{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\",\"signature\":\"0xa9059cbb\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_addedValue\",\"type\":\"uint256\"}],\"name\":\"increaseApproval\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\",\"signature\":\"0xd73dd623\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"},{\"name\":\"_spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\",\"signature\":\"0xdd62ed3e\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"spender\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\",\"signature\":\"0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"to\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\",\"signature\":\"0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef\"}]"
  end

  # let(:napp) { NApp::Client.new("http://121.196.200.225:1337") }
  let(:napp) { NApp::Client.new("http://example.com") }
  let(:contract) { napp.contract_at(abi_str, "0x3259704dff6ba09184e1fcb2c47969b4fafffb7f") }
  let(:private_key) { "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee" }
  let(:tx) do
    {
      to: "0xdf6d98d027ec42e99c7ed610a19d54271f85780d",
      nonce: "32",
      quota: 30000,
      data: "",
      chain_id: 1,
      version: 0,
      from: "0x46a23e25df9a0f6c18729dda9ad1af3b6a131160",
      private_key: private_key,
      value: "0",
      valid_until_block: 2252940
      # valid_until_block: napp.rpc.block_number["result"].hex + 88
    }
  end

  let(:transfer_addr) { "0xdf6d98d027ec42e99c7ed610a19d54271f85780d" }
  let(:contract_addr) { "0x3259704dff6ba09184e1fcb2c47969b4fafffb7f" }
  let(:symbol_data) { "0x95d89b41" }
  let(:transfer_data) { "0xa9059cbb000000000000000000000000df6d98d027ec42e99c7ed610a19d54271f85780d00000000000000000000000000000000000000000000000000000000000003e8" }

  context "function data" do
    it "symbol" do
      expect(contract.function_data(:symbol)).to eq symbol_data
    end

    it "transfer 1000" do
      data = contract.function_data(:transfer, transfer_addr, 1000)
      expect(data).to eq transfer_data
    end
  end

  context "call_func" do
    it "symbol" do
      allow(napp.rpc).to receive(:call_rpc).with(:call, params: [{ data: symbol_data, to: contract_addr }, "latest"]).and_return({
                                                                                                                                   "jsonrpc" => "2.0",
                                                                                                                                   "id" => 83,
                                                                                                                                   "result" => "0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000024444000000000000000000000000000000000000000000000000000000000000"
                                                                                                                                 })
      expect(contract.call_func(method: :symbol)).to eq "DD"
    end

    it "transfer" do
      allow(napp.rpc).to receive(:call_rpc).with(:call, params: [{ data: transfer_data, to: contract_addr }, "latest"]).and_return({
                                                                                                                                     "jsonrpc" => "2.0",
                                                                                                                                     "id" => 83,
                                                                                                                                     "result" => "0x"
                                                                                                                                   })
      result = contract.call_func(method: :transfer, params: [transfer_addr, 1000])
      expect(result).to eq false
    end

    context "parse abi" do
      let(:abi) { JSON.parse(abi_str) }
      let(:contract) { napp.contract_at(abi, "0x3259704dff6ba09184e1fcb2c47969b4fafffb7f") }

      it "symbol" do
        allow(napp.rpc).to receive(:call_rpc).with(:call, params: [{ data: symbol_data, to: contract_addr }, "latest"]).and_return({
                                                                                                                                     "jsonrpc" => "2.0",
                                                                                                                                     "id" => 83,
                                                                                                                                     "result" => "0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000024444000000000000000000000000000000000000000000000000000000000000"
                                                                                                                                   })
        expect(contract.call_func(method: :symbol)).to eq "DD"
      end
    end
  end

  context "send_func" do
    before do
      allow(napp.rpc).to receive(:call_rpc).with("sendRawTransaction", params: ["0x0aa1010a28646636643938643032376563343265393963376564363130613139643534323731663835373830641202333218b0ea01208cc189012a44a9059cbb000000000000000000000000df6d98d027ec42e99c7ed610a19d54271f85780d00000000000000000000000000000000000000000000000000000000000003e832200000000000000000000000000000000000000000000000000000000000000000380112417bc04767485a46a26ec8be792a661fd8aaec6daccf5a2bf49d0dc287790db5bb43fbaa6a30d7cf3fa97120d8e3f296105f74eda5ee4811fc0978ef401f16d82901"]).and_return({
               "jsonrpc" => "2.0",
               "id" => 83,
               "result" => {
                 "hash" => "0x5d6455c4e3abedfad06090e885368b9c5780d535cd1dd6c817641b4d91fe32be",
                 "status" => "OK"
               }})
    end

    it "transfer" do
      expect(contract.send_func(tx: tx, private_key: private_key, method: :transfer, params: [transfer_addr, 1000])["status"]).to eq "OK"
    end

    it "transfer with transaction" do
      transaction = NApp::Transaction.from_hash(tx)
      expect(contract.send_func(tx: transaction, private_key: private_key, method: :transfer, params: [transfer_addr, 1000])["status"]).to eq "OK"
    end
  end
end
