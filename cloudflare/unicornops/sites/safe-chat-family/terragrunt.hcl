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
  build_command    = "hugo --source website --minify"
  destination_dir  = "website/public"
  root_dir         = ""
  project_name     = local.project_name
  github_repo_name = "family-chat"
  preview_environment_variables = {
    "HUGO_VERSION" = "0.159.1"
  }
  production_environment_variables = {
    "HUGO_VERSION" = "0.159.1"
  }
  production_branch = "main"
}
