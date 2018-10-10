# NApp.rb

[![Build Status](https://travis-ci.org/cryptape/napp.rb.svg?branch=master)](https://travis-ci.org/cryptape/napp.rb)

Nervos AppChain Ruby SDK

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'napp.rb', github: "cryptape/napp.rb"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install napp.rb

## Usage

See `keccak256`, `to_hex` and other utils methods in `NApp::Utils` module

rpc calls [RPC list](https://docs.nervos.org/cita/#/rpc_guide/rpc)
```ruby
napp = NApp::Client.new("your url")

napp.rpc.block_number
napp.rpc.get_block_by_number("0x0", true)
# or
napp.rpc.getBlockByNumber("0x0", true) 
```

sign and unsign
```ruby
# make a Transaction object first
transaction = NApp::Transaction.new(
  to: "8ff0f5b85fba9a6429e2e256880291774f8e224f",
  nonce: "e4f195c409fe47c58a624de37c730679",
  quota: 30000,
  valid_until_block: 1882078,
  data: "",
  value: "0x3e8",
  chain_id: 1,
  version: 0
)

# sign transaction with your private key
content = NApp::TransactionSigner.encode(transaction, "you private key")

# you can unsign content by `decode` method
NApp::TransactionSigner.decode(content) 
```

send transaction
```ruby
napp.rpc.send_transaction(transaction, private_key)
```

transfer tokens
```ruby
napp.rpc.transfer(to: "to address", value: 1000, private_key)
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cryptape/napp.rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the napp.rb project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cryptape/napp.rb/blob/master/CODE_OF_CONDUCT.md).
