RSpec.describe CITA::Http do
  let(:url) { "http://www.example.com" }
  let(:http) { CITA::Http.new(url) }

  def change_hash_keys(hash, method = :to_s)
    hash.map(&-> (k, v) { {k.send(method) => v} }).reduce({}, :merge)
  end

  context "conn" do
    it "headers include content type json" do
      expect(http.conn.headers["Content-Type"]).to eq "application/json"
    end
  end

  context "rpc_params" do
    let(:method) { "testMethod" }
    let(:jsonrpc) { "3.0" }
    let(:id) { 38 }
    let(:params) { ["0x0"] }
    let(:default_params) do
      {
        jsonrpc: CITA::Http::DEFAULT_JSONRPC,
        id: CITA::Http::DEFAULT_ID,
        method: method,
        params: CITA::Http::DEFAULT_PARAMS
      }
    end

    it "default" do
      expect(JSON.parse(http.rpc_params(method))).to eq change_hash_keys(default_params)
    end

    it "alter jsonrpc" do
      expect(JSON.parse(http.rpc_params(method, jsonrpc: jsonrpc))).to eq change_hash_keys(default_params.merge(jsonrpc: jsonrpc))
    end

    it "alter id" do
      expect(JSON.parse(http.rpc_params(method, id: id))).to eq change_hash_keys(default_params.merge(id: id))
    end

    it "alter params" do
      expect(JSON.parse(http.rpc_params(method, params: params))).to eq change_hash_keys(default_params.merge(params: params))
    end
  end
end
