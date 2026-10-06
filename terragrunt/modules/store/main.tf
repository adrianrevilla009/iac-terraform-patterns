variable "env" {
  type = string
}

resource "terraform_data" "store" {
  input = "orders-${var.env}"
}

output "name" {
  value = terraform_data.store.input
}
