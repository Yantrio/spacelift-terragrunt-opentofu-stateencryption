terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.1"
    }
  }

  encryption {
    key_provider "pbkdf2" "passphrase" {
      passphrase = "jameshasasecretanditsthispassphrase"
    }
    method "aes_gcm" "my_method" {
      keys = key_provider.pbkdf2.passphrase
    }

    method "unencrypted" "migration" {
    }

    state {
      method = method.aes_gcm.my_method

      ## Remove the fallback block after migration:
      fallback {
        method = method.unencrypted.migration
      }
      ## Enable this after migration:
      #enforced = true
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
