terraform {
  required_version = ">= 1.9.0, < 2.0.0"
}

variable "queues" {
  type = map(object({
    retention_days = number
    consumers      = list(string)
  }))
  default = {
    orders   = { retention_days = 4, consumers = ["billing", "shipping"] }
    payments = { retention_days = 1, consumers = ["ledger"] }
  }
}

resource "terraform_data" "queue" {
  for_each = var.queues
  input = {
    name = each.key
    days = each.value.retention_days
  }
}

# Dynamic-block analogue: flatten nested lists into one keyed collection.
locals {
  subscriptions = {
    for pair in flatten([
      for q, cfg in var.queues : [for c in cfg.consumers : { key = "${q}/${c}", queue = q, consumer = c }]
    ]) : pair.key => pair
  }
}

resource "terraform_data" "subscription" {
  for_each = local.subscriptions
  input    = each.value
}

output "subscription_keys" {
  value = sort(keys(terraform_data.subscription))
}
