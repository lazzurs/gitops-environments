terraform {
  #source = "tfr:///terraform-databricks-modules/aws-workspace/databricks?version=feat%2Fnetwork_firewall"
  source = "github.com/terraform-databricks-modules/terraform-databricks-aws-workspace?ref=feat%2Fnetwork_firewall"
}

include {
  path = find_in_parent_folders()
}

# Override the provider block to use the S3 backend
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
  allowed_targets       = [".databricks.com"]
  denied_targets        = [""]
  tags = {
    "Owner"       = "test"
    "Environment" = "test"
  }
}
