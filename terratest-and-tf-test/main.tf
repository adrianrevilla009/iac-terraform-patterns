terraform {
  required_version = ">= 1.9.0, < 2.0.0"
}

variable "env" {
  type    = string
  default = "dev"
}

locals {
  name = "orders-${var.env}"
}

output "name" {
  value = local.name
}
