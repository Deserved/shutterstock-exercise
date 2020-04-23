INSTANCE_ID?=

.PHONY: build
build:
	@terragrunt apply --terragrunt-non-interactive --auto-approve

local:
	@bash src/local $(INSTANCE_ID)

destroy:
	@terragrunt destroy --terragrunt-non-interactive