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
  vulnerability_alerts = true
  visibility           = "private"
  description          = "Repo for the cloud-weather-map project"
  has_issues           = true
  has_wiki             = true
}
