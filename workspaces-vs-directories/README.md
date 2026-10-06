# workspaces-vs-directories

A root `main.tf` driven by `terraform.workspace`, and a separate root in `envs/prod` with its own values.

## Goal

Compare two ways to run one config for several environments: workspaces on the same code, and one directory per environment.

## Run it

```
terraform init && terraform workspace new prod && terraform apply -auto-approve && terraform output workers
terraform destroy -auto-approve
```

For the directory style:

```
cd envs/prod && terraform init && terraform apply -auto-approve && terraform output workers
```

Expected: in the `prod` workspace `workers` lists `prod-worker-0`, `prod-worker-1`, `prod-worker-2`. In `default` it lists one entry, `default-worker-0`. `envs/prod` prints the same three `prod-worker-*` values.

Not run end to end: these commands could not be executed while writing this README, so the output above is read from the code.

## What it proves

- In `main.tf`, `lookup(local.sizes, terraform.workspace, 1)` gives 3 workers for `prod` and 1 for `default` (and for any other workspace name) from the same code.
- `envs/prod/main.tf` hard-codes `count = 3`, so the environment is visible in the file and has its own state in its own directory.
- Both styles produce the same worker names, so the difference is in state and review, not in the result.

## Trade-offs

- Workspaces are cheap, but the active environment is hidden in CLI state, and all of them share one backend and credentials.
- Directories duplicate code, but blast radius and diffs per environment are explicit.
- Here the directory copy is a plain duplicate; in real use you would share a module between environments.

## When not to use it

- Do not use workspaces to separate prod from non-prod accounts; use directories or Terragrunt.
- Do not copy whole directories per environment when a shared module can express the difference.
