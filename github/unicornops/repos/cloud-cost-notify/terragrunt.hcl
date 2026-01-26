terraform {
  source = "tfr:///mineiros-io/repository/github?version=0.18.0"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Indicate what region to deploy the resources into
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "github" {
  owner = "${local.org_vars.github_owner}"
}
terraform {
  backend "s3" {}
}
EOF
}

locals {
  org_vars  = yamldecode(file(find_in_parent_folders("org.yaml")))
  repo_name = basename(get_terragrunt_dir())
}

inputs = {
  name                 = local.repo_name
  vulnerability_alerts = true
  visibility           = "public"
  description          = "Repo for the ${local.repo_name} project"
  has_issues           = true
  has_wiki             = true
  //branch_protections_v3 = [
  //  {
  //    branch                          = "main"
  //    require_signed_commits          = false
  //    require_code_owner_reviews      = true
  //    required_approving_review_count = 1
  //    dismiss_stale_reviews           = true
  //    require_conversation_resolution = true
  //    restrict_pushes                 = true
  //    restrict_admins                 = false
  //  }
  //]
}
