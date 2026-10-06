# remote-state-locking

A local backend that writes state to `state/orders.tfstate`, plus `s3-backend.tf.example` for the S3 variant.

## Goal

Keep state outside the default working-directory location behind a backend that locks it while a write is in progress.

## Run it

```
terraform init && terraform apply -auto-approve && ls state
terraform destroy -auto-approve
```

Expected: `ls state` lists `orders.tfstate`, and the `value` output is `orders-v1`.

`s3-backend.tf.example` is not loaded by Terraform (the `.example` suffix). To try it, replace the `backend "local"` block in `main.tf` with its contents and point the endpoint at LocalStack (`http://localhost:4566`) or a real bucket. It uses `use_lockfile = true`, which needs Terraform 1.10 or newer and no DynamoDB table. A real bucket costs cents; delete it after `terraform destroy`.

Not run end to end: neither the local backend nor the S3 variant was executed while writing this README. The S3 example was never tested against LocalStack.

## What it proves

- `backend "local"` in `main.tf` moves state to `state/orders.tfstate` instead of `terraform.tfstate`.
- While `apply` runs, Terraform holds a lock on that state file, so a second concurrent run on the same machine is refused.
- The S3 example shows the only changes needed for team-wide locking: bucket, key, region and `use_lockfile`.

## Trade-offs

- The local backend locks only on one machine; it gives no protection across a team.
- S3 needs bucket versioning, IAM permissions, and occasionally `terraform force-unlock` for a stale lock.
- Backend blocks cannot use variables, so each environment needs its own copy or `-backend-config` flags.

## When not to use it

- Solo throwaway experiments, where default local state is enough.
- When a managed service such as HCP Terraform already stores and locks your state.
