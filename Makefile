.DEFAULT_GOAL:=help
SHELL = /bin/sh

# main receipts
.PHONY: deps build clean help
# receipts for Code Quality
.PHONY: code-quality lint-ruby-code format-ruby-code
# receipts for Testing
.PHONY: test test-unit test-intergration

.SILENT: help

# DEFINE FUNCTIONS

define get_current_version
	sed -nE '/VERSION = /s/(.+)"(.+)"/\2/p' lib/cita/version.rb
endef

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


# receipts for Release
.PHONY: changelog changelog-check generate-build-version show-full-version
##@ Release
changelog-check:
	# check local branch
	@git_tags_count=$(shell git log --oneline --decorate | grep "tag:" | wc -l | bc) ; \
		if [ $${git_tags_count} == 0 ]; then \
			echo "No git tags found on current branch, please follow these steps:" ;\
			echo "1. $$ git checkout master" ;\
			echo "2. $$ git checkout -b update-changelog" ;\
			echo "3. $$ git merge develop --no-edit" ;\
			echo "4. $$ make changelog" ;\
			echo "or just run $$ make changelog-auto" ;\
			exit 1 ;\
		fi

changelog: changelog-check ## Generate CHANGELOG.md from git logs.
	$(info How do I make a good changelog? https://keepachangelog.com)
	# auto install git-changelog
	@git-changelog -v || pip3 install git-changelog
	@OUTPUT=CHANGELOG.md ;\
		git-changelog -s basic -t keepachangelog -o $${OUTPUT} . ;\
		git diff $${OUTPUT} ;\
		open $${OUTPUT} ;\
		echo "Edit $${OUTPUT} to keep notable changes"

changelog-auto: ## Auto generate CHANGELOG.md
	$(info Generate CHANGELOG.md in one step)
	git checkout master
	if git show-ref --verify --quiet "refs/heads/update-changelog"; then \
		echo "Found update-changelog, auto delete it." ;\
		git branch -D update-changelog ;\
	fi
	git checkout -b update-changelog
	git merge develop --no-edit
	make changelog

make commit-release-notes: ## Commit lib/cita/version.rb and CHANGELOG.md
	@eval current_version=`$(get_current_version)` ;\
	git add lib/cita/version.rb CHANGELOG.md ;\
	git commit -m "bump version to v$${current_version}" ;\
	git log -n 1

current-version: ## Show current version number in lib/cita/version.rb file
	@$(call get_current_version)

bump-version: ## Update version number in lib/cita/version.rb file, e.g.: bump-version v=1.2.0
	$(info Update version number)
	@eval current_version=`$(get_current_version)` ;\
	if [ "$${v}" == "" ]; then \
		echo "usage:$$ make bump-version v=x.y.z" ;\
	else \
		echo "Previous version: $${current_version}" ;\
		echo "Update to new version: $${v}" ;\
		sed -i '' "s/$${current_version}/$${v}/" lib/cita/version.rb ;\
		new_version=`make current-version` ;\
		echo "Now current version: $${new_version}" ;\
	fi
