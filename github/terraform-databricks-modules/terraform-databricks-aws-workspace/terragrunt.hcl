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
provider "github" {}
terraform {
  backend "s3" {}
}
EOF
}

inputs = {
  name                 = "terraform-databricks-aws-workspace"
  license_template     = "MIT"
  gitignore_template   = "Terraform"
  vulnerability_alerts = false
}
