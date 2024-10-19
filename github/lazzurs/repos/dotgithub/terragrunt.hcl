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
  org_vars = yamldecode(file(find_in_parent_folders("org.yaml")))
}

inputs = {
  name                 = ".github"
  visibility           = "public"
  license_template     = "MIT"
  vulnerability_alerts = true
}
