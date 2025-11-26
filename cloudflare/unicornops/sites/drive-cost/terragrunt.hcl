terraform {
  source = "github.com/lazzurs/terraform-cloudflare-pages-github?ref=v0.1.0"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Indicate what region to deploy the resources into
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
EOF
}

locals {
  project_name = basename(get_terragrunt_dir())
}

inputs = {
  build_command                    = "make build"
  destination_dir                  = "dist"
  root_dir                         = "/"
  project_name                     = local.project_name
  github_repo_name                 = "drive-cost"
  preview_environment_variables    = {
    "CF_PAGES_PROJECT_NAME" = local.project_name
  }
  production_environment_variables = {
    "CF_PAGES_PROJECT_NAME" = local.project_name
  }
  production_branch                = "main"
}
