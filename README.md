# iac-terraform-patterns

Ten small Terraform folders, each showing one pattern (modules, state, environments, refactoring, testing, linting) that works without a cloud account, so you can see how the pattern is wired in a few minutes.

## What is inside

| Folder | What it shows | Run |
| --- | --- | --- |
| [`modules`](./modules) | A child module with typed, validated inputs and an output, called twice | `terraform init && terraform apply -auto-approve && terraform output stores` |
| [`remote-state-locking`](./remote-state-locking) | State kept at a configured backend path, plus an S3 variant with lockfile locking | `terraform init && terraform apply -auto-approve && ls state` |
| [`workspaces-vs-directories`](./workspaces-vs-directories) | One config per environment via workspaces versus a directory per environment | `terraform init && terraform workspace new prod && terraform apply -auto-approve && terraform output workers` |
| [`for-each-dynamic-blocks`](./for-each-dynamic-blocks) | `for_each` over a map and a flattened keyed collection | `terraform init && terraform apply -auto-approve && terraform output subscription_keys` |
| [`data-sources`](./data-sources) | A `data` block reading a file written by another resource | `terraform init && terraform apply -auto-approve && terraform output region` |
| [`lifecycle-moved-import`](./lifecycle-moved-import) | `moved`, `lifecycle` arguments and a documented `import` block | `terraform init && terraform plan` |
| [`terratest-and-tf-test`](./terratest-and-tf-test) | Plan-time assertions with `terraform test` | `terraform init && terraform test` |
| [`tflint-checkov`](./tflint-checkov) | Static lint and security scan of an S3 bucket definition | `tflint --init && tflint && checkov -d . --framework terraform --quiet --compact` |
| [`terragrunt`](./terragrunt) | One root config and one small file per environment sharing a module | `cd live/dev && terragrunt apply --non-interactive` |
| [`opentofu`](./opentofu) | The same HCL run with the `tofu` binary | `tofu init && tofu apply -auto-approve && tofu output name` |

All folders use the same tiny Orders domain for names and values. Run each command from inside its folder.

## Prerequisites

- Terraform 1.9 or newer (1.10+ if you try the S3 lockfile example)
- tflint and checkov for `tflint-checkov`
- Terragrunt 0.67+ for `terragrunt`
- OpenTofu 1.8+ for `opentofu`
- Network access to download the `hashicorp/local` provider (`data-sources`) and `hashicorp/aws` (`tflint-checkov`)

## How to read it

Start with `modules`, then `workspaces-vs-directories` and `lifecycle-moved-import`. The last four (`tflint-checkov`, `terragrunt`, `opentofu`, `terratest-and-tf-test`) are tooling around the same HCL. None of the commands were run end to end when these READMEs were written; each folder README says what to expect.
