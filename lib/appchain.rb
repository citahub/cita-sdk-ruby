# frozen_string_literal: true

require "appchain/version"

module AppChain
  # Your code goes here...
  require "appchain/protos/blockchain_pb"

  require "web3_eth/contract"

  require "appchain/address"
  require "appchain/transaction"
  require "appchain/transaction_signer"
  require "appchain/utils"
  require "appchain/http"
  require "appchain/rpc"
  require "appchain/client"
  require "appchain/contract"
end
