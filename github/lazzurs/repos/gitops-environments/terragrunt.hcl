terraform {
  source = "tfr:///mineiros-io/repository/github?version=0.18.0"
}

include {
  path = find_in_parent_folders()
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
  gitignore_template   = "Terraform"
  vulnerability_alerts = true
  visibility           = "public"
  description          = "Repo for control of all of my cloud usage using Terragrunt to control."
  has_issues           = true
}
