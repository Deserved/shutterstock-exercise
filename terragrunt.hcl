terraform_version_constraint = "~> 0.12"

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "shutterstock-vs"
    key            = "application"
    dynamodb_table = "shutterstock-terraform-state-lock"
    encrypt        = true
    region         = "eu-west-1"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region              = "eu-west-1"
  version             = "~> 2.42"
}
EOF
}

terraform {
  source = "src/terraform"

  before_hook "build_lambda" {
    commands = ["apply"]
    execute = ["src/build", get_terragrunt_dir()]
    run_on_error = false
  }

  after_hook "apocalypsis" {
    commands = ["destroy"]
    execute = [
      "rm",
      "-rf",
      format("%s/src/env.json", get_terragrunt_dir()),
      format("%s/src/event.json", get_terragrunt_dir()),
      format("%s/.terragrunt-cache", get_terragrunt_dir())
    ]
    run_on_error = false
  }
}

inputs = {
  service = "shutterstock-exercise"
  path_to_package = format("%s/src/package/function.zip", get_terragrunt_dir())
  path_to_dataset = format("%s/src/dataset/instances.json", get_terragrunt_dir())
  path_for_env = format("%s/src/env.json", get_terragrunt_dir())
}