# AppChain.rb

[![Build Status](https://travis-ci.org/cryptape/appchain.rb.svg?branch=master)](https://travis-ci.org/cryptape/appchain.rb)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](https://www.rubydoc.info/github/cryptape/appchain.rb/master)

Nervos AppChain Ruby SDK

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'appchain.rb', github: "cryptape/appchain.rb"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install appchain.rb

## Usage

See `keccak256`, `to_hex` and other utils methods in `AppChain::Utils` module

rpc calls [RPC list](https://docs.nervos.org/cita/#/rpc_guide/rpc)
```ruby
appchain = AppChain::Client.new("your url")

appchain.rpc.block_number
appchain.rpc.get_block_by_number("0x0", true)
# or
appchain.rpc.getBlockByNumber("0x0", true) 
```

sign and unsign
```ruby
# make a Transaction object first
transaction = AppChain::Transaction.new(
  to: "8ff0f5b85fba9a6429e2e256880291774f8e224f",
  nonce: "e4f195c409fe47c58a624de37c730679",
  quota: 30000,
  valid_until_block: 1882078,
  data: "",
  value: "0x3e8",
  chain_id: "1",
  version: 1
)

# sign transaction with your private key
content = AppChain::TransactionSigner.encode(transaction, "you private key")

# you can unsign content by `decode` method
AppChain::TransactionSigner.decode(content) 
```

send transaction
```ruby
appchain.rpc.send_transaction(transaction, private_key)
```

transfer tokens
```ruby
appchain.rpc.transfer(to: "to address", value: 1000, private_key)
```

contract
```ruby
contract = appchain.contract_at(abi, contract_address)
# for rpc call (constant functions)
response = contract.call_func(method: :symbol)
# for rpc sendTransaction
response = contract.send_func(tx: tx, private_key: private_key, method: :transfer, params: [address, tokens])
```

## CHANGELOG

### v0.1

* supports CITA 0.19

### 0.2
 
* supports CITA 0.20 and 0.19
* set default transaction version to 1
* update TransactionSinger.decode output type to hash with symbol keys
* parse TransactionSinger.decode hash value to hex string if it's bytes. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cryptape/appchain.rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the appchain.rb project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cryptape/appchain.rb/blob/master/CODE_OF_CONDUCT.md).
