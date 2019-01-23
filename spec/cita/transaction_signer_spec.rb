RSpec.describe CITA::TransactionSigner do
  let(:private_key) { "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee" }


  context "encode" do
    context "test transfer" do
      let(:tx_hash) do
        {
          to: "8ff0f5b85fba9a6429e2e256880291774f8e224f",
          nonce: "e4f195c409fe47c58a624de37c730679",
          quota: 30000,
          valid_until_block: 1882078,
          data: "",
          value: "0x3e8",
          chain_id: 1,
          version: 0
        }
      end
      let(:content) { "0x0a780a28386666306635623835666261396136343239653265323536383830323931373734663865323234661220653466313935633430396665343763353861363234646533376337333036373918b0ea0120deef72322000000000000000000000000000000000000000000000000000000000000003e8380112410fc6ff3fe2c84d716c2b7ffa198c121440fd926c9c7b36ca1e952e2d42bab20d05b828c2ef792a6484a312ee6e41d3cca4ea32bbf893ca8fa39b93d267cfdd8401" }

      it "encode correct" do
        tx = CITA::Transaction.new(tx_hash)
        result = CITA::TransactionSigner.encode(tx, private_key)
        expect(result).to eq content
      end

      it "decimal value" do
        tx_hash[:value] = 1000
        tx = CITA::Transaction.new(tx_hash)
        result = CITA::TransactionSigner.encode(tx, private_key)
        expect(result).to eq content
      end
    end

    context "with data" do
      let(:tx_hash) do
        {
          data: "6060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d405860029",
          quota: 1_000_000,
          chain_id: 1,
          version: 0,
          valid_until_block: 999999,
          value: "0x0",
          nonce: "12345",
          # from: "0x46a23e25df9a0f6c18729dda9ad1af3b6a131160"
        }
      end
      let(:content) { "0x0aa6021205313233343518c0843d20bf843d2af0016060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d4058600293220000000000000000000000000000000000000000000000000000000000000000038011241c7b51f2b634a2bb6acb0956a11f71889a88c4bbac2098b39bc3c5c0e151b45931217c0d1e30c1bec872e619273003098e453332c89690b0670fb02a35a53808e00" }

      it "encode correct" do
        tx = CITA::Transaction.new(tx_hash)
        result = CITA::TransactionSigner.encode(tx, private_key)
        expect(result).to eq content
      end
    end
  end


  context "decode" do
    let(:content) { "0x0aa6021205313233343518c0843d20bf843d2af0016060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d4058600293220000000000000000000000000000000000000000000000000000000000000000038011241c7b51f2b634a2bb6acb0956a11f71889a88c4bbac2098b39bc3c5c0e151b45931217c0d1e30c1bec872e619273003098e453332c89690b0670fb02a35a53808e00" }
    let(:data) { "6060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d405860029" }
    let(:expect_data) do
      {
        unverified_transaction: {
          transaction: {
            to: "",
            nonce: "12345",
            quota: 1_000_000,
            valid_until_block: 999999,
            data: CITA::Utils.to_bytes(data),
            value: CITA::TransactionSigner.send(:hex_to_bytes, "0x0"),
            chain_id: 1,
            version: 0
          },
          signature: "\xC7\xB5\x1F+cJ+\xB6\xAC\xB0\x95j\x11\xF7\x18\x89\xA8\x8CK\xBA\xC2\t\x8B9\xBC<\\\x0E\x15\eE\x93\x12\x17\xC0\xD1\xE3\f\e\xEC\x87.a\x92s\x000\x98\xE4S3,\x89i\v\x06p\xFB\x02\xA3ZS\x80\x8E\x00",
          crypto: :DEFAULT
        },
        sender: {
          address: "0x46a23e25df9a0f6c18729dda9ad1af3b6a131160",
          public_key: "0xa706ad8f73115f90500266f273f7571df9429a4cfb4bbfbcd825227202dabad1ba3d35c73aec698af852b327ba1c24e11758936bb6322fe93d7469b182f66631"
        }
      }
    end

    it "original decode" do
      data = CITA::TransactionSigner.original_decode(content)

      expect(data[:unverified_transaction][:transaction]).to eq expect_data[:unverified_transaction][:transaction]
      expect(data[:unverified_transaction][:crypto]).to eq expect_data[:unverified_transaction][:crypto]
      expect(data[:sender]).to eq expect_data[:sender]
    end

    it "decode" do
      output = CITA::TransactionSigner.decode(content)
      utx = output[:unverified_transaction]
      tx = utx[:transaction]

      expect(tx[:to]).to eq ""
      expect(tx[:data]).to eq "0x#{data}"
      expect(tx[:value]).to eq "0x#{expect_data[:unverified_transaction][:transaction][:value].unpack1("H*")}"
      expect(utx[:signature]).to eq "0x#{expect_data[:unverified_transaction][:signature].unpack1("H*")}"
    end
  end


  context "CITA 0.20" do
    let(:private_key) { "0x5f0258a4778057a8a7d97809bd209055b2fbafa654ce7d31ec7191066b9225e6" }

    context "encode" do
      context "version 0" do
        let(:tx_hash) do
          {
            to: "9018ea8bce5d29e59c2bd1d6a10ca5e5c9e2fc3a",
            nonce: "a78c7a279bd8e2cd29104e93fc4c83d1",
            quota: 30000,
            valid_until_block: 91789,
            data: "",
            value: "0x3e8",
            chain_id: 1,
            version: 0
          }
        end
        let(:content) { "0x0a780a28393031386561386263653564323965353963326264316436613130636135653563396532666333611220613738633761323739626438653263643239313034653933666334633833643118b0ea01208dcd05322000000000000000000000000000000000000000000000000000000000000003e8380112412b87476f127f19e91a5de9228550ae1476612d9d2a1ce9c63b9647b4dd48942e17101588f3301aad8f6a357d0eee441873c0fc384276cd1ff6d9f736759a5b1d00" }

        it "encode correct" do
          tx = CITA::Transaction.new(tx_hash)
          result = CITA::TransactionSigner.encode(tx, private_key)
          expect(result).to eq content
        end
      end

      context "version 1" do
        let(:tx_hash) do
          {
            to: "9018ea8bce5d29e59c2bd1d6a10ca5e5c9e2fc3a",
            nonce: "3cd9407e421f10195c186959bbed3915",
            quota: 30000,
            valid_until_block: 91117,
            data: "",
            value: "0x3e8",
            chain_id: "1",
            version: 1
          }
        end
        let(:content) { "0x0a86011220336364393430376534323166313031393563313836393539626265643339313518b0ea0120edc705322000000000000000000000000000000000000000000000000000000000000003e840014a149018ea8bce5d29e59c2bd1d6a10ca5e5c9e2fc3a522000000000000000000000000000000000000000000000000000000000000000011241f0aa9ddaad8f05698910de7ab40c0d1bd2f510988a4d2581fd00a6948bef422c787d30fdbfde1ec7fd10eb7d6b826c5864b8d1bd9e4cf87022824e2b9a25e66100" }

        it "encode correct" do
          tx = CITA::Transaction.new(tx_hash)
          result = CITA::TransactionSigner.encode(tx, private_key)
          expect(result).to eq content
        end
      end
    end

    context "decode" do
      context "version 0" do
        let(:content) do
          "0x0a780a28393031386561386263653564323965353963326264316436613130636135653563396532666333611220613738633761323739626438653263643239313034653933666334633833643118b0ea01208dcd05322000000000000000000000000000000000000000000000000000000000000003e8380112412b87476f127f19e91a5de9228550ae1476612d9d2a1ce9c63b9647b4dd48942e17101588f3301aad8f6a357d0eee441873c0fc384276cd1ff6d9f736759a5b1d00"
        end
        let(:data) { "" }
        let(:expected_data) do
          {
            unverified_transaction: {
              transaction: {
                to: "9018ea8bce5d29e59c2bd1d6a10ca5e5c9e2fc3a",
                nonce: "a78c7a279bd8e2cd29104e93fc4c83d1",
                quota: 30000,
                valid_until_block: 91789,
                data: data,
                value: CITA::TransactionSigner.send(:hex_to_bytes, "0x3e8"),
                chain_id: 1,
                version: 0,
              },
              signature: "+\x87Go\x12\x7F\x19\xE9\x1A]\xE9\"\x85P\xAE\x14va-\x9D*\x1C\xE9\xC6;\x96G\xB4\xDDH\x94.\x17\x10\x15\x88\xF30\x1A\xAD\x8Fj5}\x0E\xEED\x18s\xC0\xFC8Bv\xCD\x1F\xF6\xD9\xF76u\x9A[\x1D\x00",
              crypto: :DEFAULT
            },
            sender: {
              address: "0x4b5ae4567ad5d9fb92bc9afd6a657e6fa13a2523",
              public_key: "0xd2bdee2f7bbf540e1bef0a081f317bc8d99eb0777e6fd9e30cc1ddc220a17a0c2a18d56b4c1727149a2571a4ad25f1ff58f631c6a4ab3cd518d2fd695313acc2"
            }
          }
        end

        it "original decode" do
          data = CITA::TransactionSigner.original_decode(content)

          expect(data[:unverified_transaction][:transaction].to_h).to eq expected_data[:unverified_transaction][:transaction]
          expect(data[:unverified_transaction][:crypto]).to eq expected_data[:unverified_transaction][:crypto]
          expect(data[:sender]).to eq expected_data[:sender]
        end

        it "decode" do
          output = CITA::TransactionSigner.decode(content)
          utx = output[:unverified_transaction]
          tx = utx[:transaction]

          expect(tx[:to]).to eq "0x#{expected_data[:unverified_transaction][:transaction][:to]}"
          expect(tx[:data]).to eq ""
          expect(tx[:value]).to eq "0x#{expected_data[:unverified_transaction][:transaction][:value].unpack1("H*")}"
          expect(utx[:signature]).to eq "0x#{expected_data[:unverified_transaction][:signature].unpack1("H*")}"
        end
      end

      context "version 1" do
        let(:content) { "0x0a86011220336364393430376534323166313031393563313836393539626265643339313518b0ea0120edc705322000000000000000000000000000000000000000000000000000000000000003e840014a149018ea8bce5d29e59c2bd1d6a10ca5e5c9e2fc3a522000000000000000000000000000000000000000000000000000000000000000011241f0aa9ddaad8f05698910de7ab40c0d1bd2f510988a4d2581fd00a6948bef422c787d30fdbfde1ec7fd10eb7d6b826c5864b8d1bd9e4cf87022824e2b9a25e66100" }
        let(:data) { "" }
        let(:expected_data) do
          {
            unverified_transaction: {
              transaction: {
                to: ["9018ea8bce5d29e59c2bd1d6a10ca5e5c9e2fc3a"].pack("H*"),
                nonce: "3cd9407e421f10195c186959bbed3915",
                quota: 30000,
                valid_until_block: 91117,
                data: data,
                value: CITA::TransactionSigner.send(:hex_to_bytes, "0x3e8"),
                chain_id: CITA::TransactionSigner.send(:hex_to_bytes, "0x1"),
                version: 1
              },
              signature: "\xF0\xAA\x9D\xDA\xAD\x8F\x05i\x89\x10\xDEz\xB4\f\r\e\xD2\xF5\x10\x98\x8AM%\x81\xFD\x00\xA6\x94\x8B\xEFB,x}0\xFD\xBF\xDE\x1E\xC7\xFD\x10\xEB}k\x82lXd\xB8\xD1\xBD\x9EL\xF8p\"\x82N+\x9A%\xE6a\x00",
              crypto: :DEFAULT
            },
            sender: {
              address: "0x4b5ae4567ad5d9fb92bc9afd6a657e6fa13a2523",
              public_key: "0xd2bdee2f7bbf540e1bef0a081f317bc8d99eb0777e6fd9e30cc1ddc220a17a0c2a18d56b4c1727149a2571a4ad25f1ff58f631c6a4ab3cd518d2fd695313acc2"
            }
          }
        end

        it "original decode" do
          data = CITA::TransactionSigner.original_decode(content)

          expect(data[:unverified_transaction][:transaction].to_h).to eq expected_data[:unverified_transaction][:transaction]
          expect(data[:unverified_transaction][:crypto]).to eq expected_data[:unverified_transaction][:crypto]
          expect(data[:sender]).to eq expected_data[:sender]
        end

        it "decode" do
          output = CITA::TransactionSigner.decode(content)
          utx = output[:unverified_transaction]
          tx = utx[:transaction]

          expect(tx[:to]).to eq "0x#{expected_data[:unverified_transaction][:transaction][:to].unpack1("H*")}"
          expect(tx[:data]).to eq ""
          expect(tx[:value]).to eq "0x#{expected_data[:unverified_transaction][:transaction][:value].unpack1("H*")}"
          expect(utx[:signature]).to eq "0x#{expected_data[:unverified_transaction][:signature].unpack1("H*")}"
        end
      end
    end
  end
end
