variable "name" {
  type        = string
  description = "Logical store name"
  validation {
    condition     = can(regex("^[a-z]+$", var.name))
    error_message = "name must be lowercase letters."
  }
}

variable "env" {
  type    = string
  default = "dev"
}

variable "tags" {
  type    = map(string)
  default = {}
}

locals {
  id = "${var.env}-${var.name}"
}

# Built-in resource: no provider download, no cloud account.
resource "terraform_data" "store" {
  input = merge(var.tags, { id = local.id })
}

output "id" {
  value = terraform_data.store.input.id
}
