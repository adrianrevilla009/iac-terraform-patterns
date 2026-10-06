# modules

A root `main.tf` that calls the child module `order-store/` twice with different inputs.

## Goal

Show a reusable child module with a typed and validated input, defaults and an output, and how a root reads only the output.

## Run it

```
terraform init && terraform apply -auto-approve && terraform output stores
terraform destroy -auto-approve
```

Expected: `stores` is a map with `orders = "dev-orders"` and `payments = "dev-payments"`. The module only uses the built-in `terraform_data` resource, so no provider download or cloud account is needed.

Not run end to end: the command could not be executed while writing this README, so the output above is read from the code, not captured.

## What it proves

- `module "orders_bucket"` and `module "payments_bucket"` in `main.tf` both use `./order-store` with different `name` values; the id is built as `<env>-<name>` in `order-store/main.tf`.
- `name` has a `validation` block in `order-store/main.tf`; anything but lowercase letters (for example `Orders1`) fails at plan time.
- `tags` is optional (default `{}`) and is merged into the resource input; the root reads only `module.<name>.id`.

## Trade-offs

- A module this small adds a directory and a layer of indirection for one resource.
- Inputs with defaults (`env`, `tags`) are convenient but let callers drift apart silently.
- `terraform_data` stands in for a real resource, so the module shows structure, not provider behaviour.

## When not to use it

- For a single one-off resource used in one place.
- When the module would only forward every argument of one resource unchanged.
