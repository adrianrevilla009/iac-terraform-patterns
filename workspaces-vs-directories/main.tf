terraform {
  required_version = ">= 1.9.0, < 2.0.0"
}

# Workspaces share code and backend; only terraform.workspace changes.
locals {
  sizes = {
    default = 1
    prod    = 3
  }
  replicas = lookup(local.sizes, terraform.workspace, 1)
}

resource "terraform_data" "worker" {
  count = local.replicas
  input = "${terraform.workspace}-worker-${count.index}"
}

output "workers" {
  value = terraform_data.worker[*].input
}
