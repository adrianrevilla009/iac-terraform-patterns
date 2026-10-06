# terratest-and-tf-test

A tiny `main.tf` that builds `orders-<env>`, and `naming.tftest.hcl` with two plan-time test runs.

## Goal

Test Terraform with the built-in `terraform test` command using HCL assertions. Terratest (Go) is only described here; there is no Go code in the folder.

## Run it

```
terraform init && terraform test
```

Expected: both runs, `default_name` and `prod_name`, are reported as `pass`, followed by a summary of 2 passed, 0 failed.

Not run end to end: the command could not be executed while writing this README, so the output above is read from the code.

## What it proves

- `default_name` plans with the default `env` and asserts `output.name == "orders-dev"`.
- `prod_name` overrides `env = "prod"` in its `variables` block and asserts `orders-prod`.
- Both use `command = plan`, so nothing is created and the test needs no cleanup.

## Trade-offs

- `terraform test` is built in and fast, but its assertions are HCL only and cover what a plan can compute.
- Terratest (Go: `terraform.InitAndApply`, then assertions on outputs or real endpoints) checks deployed behaviour, but needs Go and real apply time.
- The config under test is a single local value, so the test shows the mechanism, not a realistic suite.

## When not to use it

- Skip tests for trivial configs with no logic.
- Use Terratest or an apply-based test when you must verify a deployed endpoint.
