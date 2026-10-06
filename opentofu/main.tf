terraform {
  required_version = ">= 1.8.0"
}

variable "env" {
  type    = string
  default = "dev"
}

# Only the shared core is used: this exact file also runs under Terraform.
resource "terraform_data" "orders" {
  input = "orders-${var.env}"
}

output "name" {
  value = terraform_data.orders.output
}
