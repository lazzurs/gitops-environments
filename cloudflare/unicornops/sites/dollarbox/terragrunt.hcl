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
  build_command                    = "curl -sL https://github.com/getzola/zola/releases/download/v0.19.2/zola-v0.19.2-x86_64-unknown-linux-gnu.tar.gz | tar xz && cp -r theme website/static/ && ./zola --root website build"
  destination_dir                  = "website/public"
  root_dir                         = "/"
  project_name                     = local.project_name
  github_repo_name                 = local.project_name
  preview_environment_variables    = {}
  production_environment_variables = {}
  production_branch                = "main"
}
