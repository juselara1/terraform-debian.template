SHELL := /usr/bin/env bash

##@ General
.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[%a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development Environment
build-devenv: ## Builds the development environment.
	docker compose build

connect-devenv: ## Connects to the development environment.
	docker compose up -d
	docker exec -it {{ cookiecutter.project_slut }}-devenv bash

##@ Terraform
init-state-%: ## Init the terraform state
	pushd "envs/init_state" && ../utils.sh deploy_state `echo $@ | awk -F '-' '{print $$3}'` && popd

plan-%: ## Create terraform plan
	pushd "envs/$$(echo $@ | awk -F '-' '{print $$2}')" && ../utils.sh plan && popd

show-%: ## Shows the terraform plan
	pushd "envs/$$(echo $@ | awk -F '-' '{print $$2}')" && ../utils.sh show && popd

deploy-%: ## Deploy terraform
	pushd "envs/$$(echo $@ | awk -F '-' '{print $$2}')" && ../utils.sh deploy && popd
