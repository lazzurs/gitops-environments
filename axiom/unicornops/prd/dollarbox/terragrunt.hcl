terraform {
  source = "."
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "axiom" {}

terraform {
  backend "s3" {}
  required_providers {
    axiom = {
      source = "axiomhq/axiom"
      version = "1.5.0"
    }
  }
}
EOF
}

locals {
  env_vars = yamldecode(file(find_in_parent_folders("env.yaml")))
  basename = basename(get_terragrunt_dir())
}

inputs = {
  dataset_name = "${local.basename}-${local.env_vars.environment_name}"
}
