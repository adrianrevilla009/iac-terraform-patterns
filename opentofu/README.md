# opentofu

A `main.tf` that uses only the shared HCL core and the built-in `terraform_data` resource.

## Goal

Run the same HCL with OpenTofu (`tofu`) as a drop-in replacement for `terraform`.

## Run it

```
tofu init && tofu apply -auto-approve && tofu output name
tofu destroy -auto-approve
```

Expected: the output is `"orders-dev"`. The same file also works with `terraform init && terraform apply`, since the config only requires `>= 1.8.0`.

Not run end to end: `tofu` is not installed in the environment where this README was written, so nothing here has been executed.

## What it proves

- The `terraform` block, a variable (`env`), a `terraform_data` resource and an output are accepted by both tools without changes.
- Only the binary differs; OpenTofu resolves providers from `registry.opentofu.org`, though this config uses none.
- `output.name` reads `terraform_data.orders.output`, which echoes the `input` of `orders-<env>`.

## Trade-offs

- State and providers are mostly interchangeable, but features diverge (OpenTofu has state encryption, Terraform has newer ephemeral features), so moving back is not guaranteed.
- This lab uses only the shared core, so it does not exercise any divergent feature.
- Tooling such as editors, CI actions and policy scanners may need extra setup for `tofu`.

## When not to use it

- When your organisation relies on HCP Terraform or other HashiCorp-only services.
- When a vendor support contract requires the HashiCorp binary.
