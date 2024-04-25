terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.1."
    }
  }
}

resource "random_password" "password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

output "password" {
  value = random_password.password.result
}
