terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "1.12.0"
    }
  }

  backend "s3" {
    bucket = "terragrunt-james-testing-bucket"
    key    = "spacelift/terragrunt/main.tfstate"
    region = "eu-west-1"
  }

}

provider "spacelift" {
  api_key_endpoint = "https://yantrio.app.spacelift.io"
  api_key_id       = "01HWAV7Z2WRE6Y32X9ECBBDQSB"
  api_key_secret   = "b64851b45aa14cb870eb26d58c313db60acf00b354f9db12e020a108f73298b4"
}

data "spacelift_aws_integration" "aws_integration" {
  integration_id = "01HWAWFHSK0FYRCSYZ71AK8V5Y"
}

resource "spacelift_stack" "terragrunt-stack" {
  terragrunt {
    terragrunt_version     = "0.55.15"
    use_run_all            = false
    use_smart_sanitization = true
    tool                   = "OPEN_TOFU"
  }

  autodeploy   = true
  branch       = "main"
  name         = "Terragrunt stack example - opentofu and state encryption"
  description  = "Deploys infra using Terragrunt"
  repository   = "spacelift-terragrunt-opentofu-stateencryption"
  project_root = "terragrunt"

  runner_image = "ghcr.io/opentofu/opentofu:1.7.0-rc1"
}

resource "spacelift_aws_integration_attachment" "my_stack" {
  integration_id = "01HWAWFHSK0FYRCSYZ71AK8V5Y"
  stack_id       = spacelift_stack.terragrunt-stack.id
  read           = true
  write          = true
}
