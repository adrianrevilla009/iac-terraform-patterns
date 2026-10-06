terraform {
  required_version = ">= 1.9.0, < 2.0.0"

  # Local backend locks the state file while apply runs (.terraform.tfstate.lock.info).
  # Swap this block for the S3 one in README to get team-wide locking.
  backend "local" {
    path = "state/orders.tfstate"
  }
}

resource "terraform_data" "orders" {
  input = "orders-v1"
}

output "value" {
  value = terraform_data.orders.output
}
