terraform {
  source = "git@github.com:unicornops/cloud-weather-map//terraform/lightsail?ref=terraform%2Fv0.1.0"
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

inputs = {
  domain_name = "dev.cloudweather.info"
}
