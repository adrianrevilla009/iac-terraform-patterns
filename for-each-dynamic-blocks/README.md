# for-each-dynamic-blocks

One `main.tf` that creates resources from a map with `for_each` and flattens nested lists into a keyed collection.

## Goal

Show `for_each` with stable string keys, and the flattening step that produces the input a `dynamic` block would iterate.

## Run it

```
terraform init && terraform apply -auto-approve && terraform output subscription_keys
terraform destroy -auto-approve
```

Expected: `subscription_keys` is the sorted list `orders/billing`, `orders/shipping`, `payments/ledger`.

Not run end to end: the command could not be executed while writing this README, so the output above is read from the code.

The folder has no actual `dynamic` block. `terraform_data` has no repeatable nested blocks, so the flattened `local.subscriptions` map stands in for what a `dynamic` block would loop over.

## What it proves

- `terraform_data.queue` is created once per key of `var.queues` (`orders`, `payments`).
- `local.subscriptions` turns the nested `consumers` lists into three entries keyed `queue/consumer`, and `terraform_data.subscription` uses those keys.
- Because keys are strings, removing `billing` from the list changes only `orders/billing`; with `count` the later items would shift index.

## Trade-offs

- Keys must be known at plan time, so they cannot come from resource attributes created in the same apply.
- Nested `for` and `flatten` expressions are hard to read once they go deeper than this.
- Renaming a key is a destroy and create unless you add a `moved` block.

## When not to use it

- For a short, fixed list, plain resources are clearer.
- Avoid `dynamic` blocks for one or two static nested entries.
