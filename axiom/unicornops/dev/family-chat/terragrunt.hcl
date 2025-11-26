terraform {
  source = "git@github.com:unicornops/community-alert//terraform/axiom?ref=terraform%2Fv0.6.10"
}

# Add in stub provider.tf file to ensure terragrunt can run
generate "provider" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
EOF
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = merge(yamldecode(file("../env.yaml"))
