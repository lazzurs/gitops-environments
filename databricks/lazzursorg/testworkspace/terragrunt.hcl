terraform {
  source = "github.com/terraform-databricks-modules/terraform-databricks-aws-workspace?ref=4b0d3fe023b4ec197c311a0ff2defadb0c8c5c42"
}

include {
  path = find_in_parent_folders()
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

inputs = {
  aws_region            = "eu-west-1"
  workspace_name        = "testworkspace"
  vpc_cidr              = "10.1.0.0/18"
  databricks_account_id = "7eea6300-240c-4753-8252-24af32f7da4c"
  tags = {
    "Owner"       = "test"
    "Environment" = "test"
  }
}
