terraform {
  source = "tfr:///mineiros-io/repository/github?version=0.18.0"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Indicate what region to deploy the resources into
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "github" {
  owner = "${local.org_vars.github_owner}"
}
terraform {
  backend "s3" {}
}
EOF
}

locals {
  org_vars  = yamldecode(file(find_in_parent_folders("org.yaml")))
  repo_name = basename(get_terragrunt_dir())
}

inputs = {
  name                 = local.repo_name
  license_template     = "MIT"
  vulnerability_alerts = true
  visibility           = "private"
  description          = "Static professional CV website for lazzurs.com"
  has_issues           = true
}

# The repo was created by hand with gh on 2026-10-03, so adopt it rather
# than create it. Remove this block once the import has been applied.
generate "import" {
  path      = "import.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOT
import {
  to = github_repository.repository
  id = "lazzurs.com"
}
EOT
}
