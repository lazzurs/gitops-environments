terraform {
  source = "github.com/lazzurs/terraform-routeos-home-router//ref=main"
}

include {
  path = find_in_parent_folders()
}

# Indicate what region to deploy the resources into
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "routeros" {}
terraform {
  backend "s3" {}
}
EOF
}

locals {
  org_vars = yamldecode(file(find_in_parent_folders("org.yaml")))
}

inputs = {
  interfaces = {
    wan = {
      name = "ether1"
      ip   = ""
    }
  }
}
