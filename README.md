# cita-sdk-ruby

[![Build Status](https://travis-ci.org/cryptape/cita-sdk-ruby.svg?branch=master)](https://travis-ci.org/cryptape/cita-sdk-ruby)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](https://www.rubydoc.info/github/cryptape/cita-sdk-ruby/master)

CITA Ruby SDK

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cita-sdk-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cita-sdk-ruby

## Usage

See `keccak256`, `to_hex` and other utils methods in `CITA::Utils` module

RPC calls [RPC list](https://docs.nervos.org/cita/#/rpc_guide/rpc)
```ruby
cita = CITA::Client.new("your url")

cita.rpc.block_number
cita.rpc.get_block_by_number("0x0", true)
# or
cita.rpc.getBlockByNumber("0x0", true) 
```

sign and unsign
```ruby
# make a Transaction object first
transaction = CITA::Transaction.new(
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
content = CITA::TransactionSigner.encode(transaction, "you private key")

# you can unsign content by `decode` method
CITA::TransactionSigner.decode(content) 
# you can set `recover` to false if you don't want to recover from address and public key
CITA::TransactionSigner.decode(content, recover: false)
```

send transaction
```ruby
cita.rpc.send_transaction(transaction, private_key)
```

transfer tokens
```ruby
cita.rpc.transfer(to: "to address", value: 1000, private_key: "your private key")
```

contract
```ruby
contract = cita.contract_at(abi, contract_address)
# for RPC call (constant functions)
response = contract.call_func(method: :symbol)
# for RPC sendTransaction
response = contract.send_func(tx: tx, private_key: private_key, method: :transfer, params: [address, tokens])
```

## CHANGELOG

### v0.24.0

* support transaction version = 2
* set default transaction version to 2

### v0.23.0

* add `getVersion` and `peersInfo` RPC methods

### v0.22.0

* support CITA v0.22

### v0.21.0

* add `recover` option for decode transaction, for CITA v0.21 provide `from` in `getTransaction` rpc call
* rename protobuf `Crypto` enum

### v0.20.0

* rename to `cita-sdk-ruby`
* rename top module name to `CITA`

### v0.2

* supports CITA 0.20 and 0.19
* set default transaction version to 1
* update TransactionSinger.decode output type to hash with symbol keys
* parse TransactionSinger.decode hash value to hex string if it's bytes.

### v0.1

* supports CITA 0.19

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cryptape/cita-sdk-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the cita-sdk-ruby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cryptape/cita-sdk-ruby/blob/master/CODE_OF_CONDUCT.md).
