run "default_name" {
  command = plan

  assert {
    condition     = output.name == "orders-dev"
    error_message = "default name must be orders-dev"
  }
}

run "prod_name" {
  command = plan

  variables {
    env = "prod"
  }

  assert {
    condition     = output.name == "orders-prod"
    error_message = "name must follow env"
  }
}
