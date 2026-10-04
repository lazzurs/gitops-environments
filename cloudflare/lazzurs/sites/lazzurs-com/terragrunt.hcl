include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/lazzurs/terraform-cloudflare-pages-github?ref=v0.2.1"
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
EOF
}

# The CV site (lazzurs/lazzurs.com, Zola). Pages project names can't contain
# dots, hence lazzurs-com. The DNS records for both custom domains live in
# neamh/octodns (config/lazzurs.com.yaml).
inputs = {
  project_name      = "lazzurs-com"
  github_repo_name  = "lazzurs.com"
  production_branch = "main"
  build_command     = "make cloudflare-deploy"
  destination_dir   = "public"
  root_dir          = ""

  preview_environment_variables = {
    ZOLA_VERSION = "0.23.6"
  }
  production_environment_variables = {
    ZOLA_VERSION = "0.23.6"
  }

  custom_domains = ["lazzurs.com", "www.lazzurs.com"]
}
