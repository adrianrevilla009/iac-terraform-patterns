terraform {
  required_version = ">= 1.9.0, < 2.0.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "= 2.5.2"
    }
  }
}

# A producer writes a file; a data source reads it back, like reading another team's output.
resource "local_file" "settings" {
  filename = "${path.module}/settings.json"
  content  = jsonencode({ region = "eu-west-1", retries = 3 })
}

data "local_file" "settings" {
  filename   = local_file.settings.filename
  depends_on = [local_file.settings]
}

locals {
  settings = jsondecode(data.local_file.settings.content)
}

output "region" {
  value = local.settings.region
}
