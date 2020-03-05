.DEFAULT_GOAL:=help
SHELL = /bin/sh

# main receipts
.PHONY: deps build clean help
# receipts for Code Quality
.PHONY: code-quality lint-ruby-code format-ruby-code
# receipts for Testing
.PHONY: test test-unit test-intergration

.SILENT: help

##@ Helpers

help:  ## Display help message.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-24s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


##@ Dependencies

deps: ## Download the depenedencies.
	$(info Checking and getting dependencies)
	bundle install
	make update-submodule

update-submodule: ## Download codes configured in .gitmodules.
	git submodule update --init --recursive


##@ Cleanup
clean: ## Clean up.
	$(info Cleaning up things)
	@echo Nothing to do here.


##@ Building

build: clean deps ## Compile binary targets.
	$(info Building the project)
	make build-secp256k1
	
build-secp256k1: ## Compile secp256k1
	cd secp256k1 && ./autogen.sh && ./configure --enable-module-recovery --enable-experimental --enable-module-ecdh && make && make install && cd ..


##@ Testing

test: ## Run the unit and intergration testsuites.
test: test-unit test-intergration

test-unit: ## Run the unit testsuite.
	$(info Run the unit testsuite)
	bundle exec rake spec

test-intergration: ## Run the intergration testsuite.
	$(info Run the intergration testsuite)
	@echo "TODO: run intergration test against with a CITA test chain"


##@ Code Quality
code-quality: ## Run linter & formatter.
	$(info Run linter & formatter)
	make lint-ruby-code
	make format-ruby-code

lint-ruby-code: ## Run linter for ruby codes
	$(info Run linter for ruby codes)
	bundle exec rubocop

format-ruby-code: ## Run formatter for ruby codes.
	$(info Run formatter for ruby codes)
	# cat .rubocop.yml
	bundle exec rubocop -x


##@ Continuous Integration

ci: ## Run recipes for CI.
ci: build test code-quality

