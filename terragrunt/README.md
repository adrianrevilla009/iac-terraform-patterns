# terragrunt

A root `terragrunt.hcl`, one small file each in `live/dev` and `live/prod`, and a shared module in `modules/store`.

## Goal

Keep backend config and per-environment inputs DRY: one root file defines state, each environment only sets its inputs, and all share one module.

## Run it

```
cd live/dev && terragrunt apply --non-interactive
terragrunt destroy --non-interactive
```

Expected: Terragrunt generates `backend.tf` in its cache, applies the module with `env = "dev"`, and the `name` output is `orders-dev`. Running it in `live/prod` gives `orders-prod`.

Requires Terragrunt 0.67+ and Terraform 1.9+.

Not run end to end: Terragrunt is not installed in the environment where this README was written, so nothing here has been executed.

## What it proves

- `include "root"` with `find_in_parent_folders` in each `live/*/terragrunt.hcl` pulls in the root `remote_state` block, which generates `backend.tf` with a local state path per environment.
- `terraform { source = "../../modules/store" }` points both environments at the same module.
- `inputs = { env = "dev" }` replaces a tfvars file; the only difference between the two environment files is that value.

## Trade-offs

- It adds a second tool and a second config language on top of Terraform.
- Behaviour and flag names change between Terragrunt versions.
- The state backend here is local; a real setup would use a remote one in the root file.

## When not to use it

- With two or three environments, plain directories or workspaces are simpler.
- When your team does not want an extra wrapper binary in CI.
