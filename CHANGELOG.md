# CHANGELOG

### v20.2.0

* change version naming style to `YY.MM.X` since CITA has changed it's version naming rule(https://github.com/citahub/cita/releases/tag/v20.2.0)
* add Makefile and update README, move changelog to CHANGELOG.md
* Bump rake from 10.5.0 to 12.3.3 fixes security vulnerability CVE-2020-8130
* migrate repo to citahub
* refactor codes with suggestion from make lint-ruby-code


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
