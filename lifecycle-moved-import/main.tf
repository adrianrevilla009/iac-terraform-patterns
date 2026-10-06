terraform {
  required_version = ">= 1.9.0, < 2.0.0"
}

# Renamed from terraform_data.old_name: `moved` keeps state, no destroy/create.
moved {
  from = terraform_data.old_name
  to   = terraform_data.orders
}

resource "terraform_data" "orders" {
  input = "orders-v1"

  lifecycle {
    prevent_destroy       = false
    create_before_destroy = true
    ignore_changes        = [input]
  }
}

# Adopt an existing object into state declaratively (id is the terraform_data id).
# Uncomment after creating state elsewhere; kept as a documented block:
#   import {
#     to = terraform_data.legacy
#     id = "00000000-0000-0000-0000-000000000000"
#   }

output "orders" {
  value = terraform_data.orders.id
}
