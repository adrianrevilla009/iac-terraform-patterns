# tflint-checkov

An S3 bucket with versioning and a public access block in `main.tf`, and a `.tflint.hcl` that enables the recommended tflint ruleset.

## Goal

Lint style and correctness with tflint, and scan for security misconfigurations with checkov, using static analysis only and no cloud account.

## Run it

```
tflint --init && tflint && checkov -d . --framework terraform --quiet --compact
```

Expected: tflint prints no issues or a few warnings. checkov prints a list of failed checks for `aws_s3_bucket.orders`; the checks left open on purpose are KMS encryption, access logging and replication.

Never run `apply` here: the AWS provider uses mock credentials with validation and metadata calls skipped, which are only meant to let static tools load the file.

Not run end to end: neither tool was executed while writing this README, so the expected findings come from reading the config. `tflint --init` also needs network access to download the ruleset plugin.

## What it proves

- `.tflint.hcl` turns on the `terraform` plugin with the `recommended` preset, which checks for issues such as unused declarations and missing version constraints.
- checkov evaluates each resource against its policies; `aws_s3_bucket_versioning` and `aws_s3_bucket_public_access_block` in `main.tf` are there to satisfy the versioning and public-access checks.
- The AWS provider is pinned to `5.70.0` in `required_providers`.

## Trade-offs

- Both tools are static and cannot see runtime state or real account settings.
- checkov is noisy by default; suppress findings with justified `#checkov:skip=ID:reason` comments, not blanket ignores.
- Rule sets change between releases, so pin tool versions in CI.

## When not to use it

- Do not treat a clean scan as proof of security; it only covers the rules that exist.
- For a config with no real resources, the scan has nothing to check.
