# lifecycle-moved-import

A single `terraform_data.orders` resource with a `moved` block, `lifecycle` settings and a commented `import` block.

## Goal

Refactor safely: rename a resource with `moved`, tune `lifecycle`, and see where an `import` block would go.

## Run it

```
terraform init && terraform plan
```

Expected: a plan that creates `terraform_data.orders` and has an `orders` output. To see `moved` work: change the resource name to `old_name` (and swap the `moved` block's `from`/`to` back), apply, rename it to `orders` again, then plan; the plan reports a move, not a replace.

Not run end to end: no plan or apply was executed while writing this README, so the output above is read from the code.

## What it proves

- `moved { from = terraform_data.old_name, to = terraform_data.orders }` rewrites the state address, so the object is kept instead of destroyed and recreated.
- `ignore_changes = [input]` stops Terraform from reacting when `input` changes later.
- `create_before_destroy = true` changes replacement order; `prevent_destroy` is set to `false` so the lab stays easy to clean up.

## Trade-offs

- `moved` blocks must stay until every state that uses the old address has applied them.
- `ignore_changes` can hide real drift.
- The `import` block is commented out because it needs the id of a real existing object; the id in the comment is a dummy.

## When not to use it

- Do not leave `prevent_destroy` or `ignore_changes` on as a habit; they mask problems.
- For a one-time rename in a state you fully control, `terraform state mv` is enough.
