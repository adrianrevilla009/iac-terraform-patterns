terraform {
  required_version = ">= 1.9.0, < 2.0.0"
}

# Directory approach: each env is its own root with its own state and its own values.
resource "terraform_data" "worker" {
  count = 3
  input = "prod-worker-${count.index}"
}

output "workers" {
  value = terraform_data.worker[*].input
}
