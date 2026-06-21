terraform {
  source = "github.com/lazzurs/terraform-cloudflare-pages-github?ref=v0.1.0"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

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
  build_command                    = ""
  destination_dir                  = "."
  root_dir                         = "/"
  project_name                     = local.project_name
  github_repo_name                 = local.project_name
  preview_environment_variables    = {}
  production_environment_variables = {}
  production_branch                = "gh-pages"
}
