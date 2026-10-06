# data-sources

A `local_file` resource writes `settings.json`, and a `data "local_file"` block reads it back.

## Goal

Read existing information into a config with a `data` block instead of hard-coding it.

## Run it

```
terraform init && terraform apply -auto-approve && terraform output region
terraform destroy -auto-approve
```

Expected: the output is `"eu-west-1"`, and `settings.json` appears in the folder with `region` and `retries`. `terraform init` downloads `hashicorp/local` 2.5.2 from the registry, so it needs network access.

Not run end to end: the command could not be executed while writing this README, so the output above is read from the code.

## What it proves

- `data.local_file.settings` reads `settings.json` and `jsondecode` in `locals` turns it into an object that feeds the `region` output.
- `depends_on = [local_file.settings]` makes the read wait until the file is written; without it the first plan would fail because the file does not exist.
- The producer and the reader are separate blocks, like reading a file another team owns.

## Trade-offs

- Data sources tie a plan to live external state, so a plan can change without any code change.
- `depends_on` on a data source defers the read to apply time, so the plan shows unknown values.
- Here the file is local; with real providers the same shape reads remote objects and needs credentials.

## When not to use it

- When this config owns the value and it is stable, use a variable or a resource reference instead.
- When the data could be passed in explicitly, avoid a hidden dependency on outside state.
