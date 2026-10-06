terraform {
  required_version = ">= 1.9.0, < 2.0.0"
}

module "orders_bucket" {
  source = "./order-store"
  name   = "orders"
  env    = "dev"
  tags   = { domain = "orders" }
}

module "payments_bucket" {
  source = "./order-store"
  name   = "payments"
  env    = "dev"
}

output "stores" {
  value = {
    orders   = module.orders_bucket.id
    payments = module.payments_bucket.id
  }
}
