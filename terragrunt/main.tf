terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.1"
    }
  }
}

resource "random_password" "password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "random_id" "id" {
  byte_length = 4
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}

output "id" {
  value = random_id.id.hex
}
