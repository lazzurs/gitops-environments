terraform {
  source = "tfr:///mineiros-io/organization/github?version=0.9.0"
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
  org_vars = yamldecode(file(find_in_parent_folders("org.yaml")))
}

inputs = {
  settings = {
    name                                    = local.org_vars.org_name
    description                             = "Organization for ${local.org_vars.org_name}"
    billing_email                           = "rob@lazzurs.org"
    members_can_create_pages                = true
    members_can_create_private_pages        = true
    members_can_create_private_repositories = true
    members_can_create_public_pages         = true
    members_can_create_public_repositories  = true
    members_can_create_repositories         = true
  }
}
