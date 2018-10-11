# frozen_string_literal: true

require "web3/eth"

module Web3
  module Eth
    class Contract
      class ContractInstance
        def function_data(method_name, *args)
          @contract.function_data(method_name.to_s, args)
        end
      end

      class ContractMethod
        def function_data(args)
          ["0x" + signature_hash + encode_hex(encode_abi(input_types, args)), output_types]
        end
      end

      def function_data(method_name, args)
        function = functions[method_name]
        raise "No method found in ABI: #{method_name}" unless function

        function.function_data args
      end
    end
  end
end
