#!/usr/bin/env bash

deploy_state() {
	local env="${1}"
	terraform init
	terraform validate
	terraform apply -var-file="${env}.tfvars" -auto-approve
	terraform output
}

plan() {
	terraform init
	terraform plan \
		-var-file=".tfvars" \
		-detailed-exitcode \
		-no-color \
		-out tfplan || exitcode=$?
	if [[ "${exitcode}" == 1 ]]; then
		echo "Invalid plan"
		exit 1
	elif [[ "${exitcode}" == 2 ]]; then
		echo "Plan contains changes"
	else
		echo "No changes"
	fi
}

deploy() {
	terraform apply -auto-approve tfplan
}

destroy() {
	terraform destroy \
		-var-file=".tfvars" \
		-auto-approve
}

$*
exit 0
