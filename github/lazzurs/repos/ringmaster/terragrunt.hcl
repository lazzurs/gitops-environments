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

# Ringmaster: voice commands from a smart ring (webhook -> local whisper.cpp
# transcription -> Claude agent with MCP tools -> ntfy). Public, so GitHub-hosted
# Actions runners are free; releases push the image to ghcr.io/lazzurs/ringmaster.
# auto_init gives main a first commit, so the code arrives through a pull request.
# main is protected: pull requests only (no approvals needed, Rob works alone),
# the CI jobs below must pass, no force pushes or deletion.
inputs = {
  name                   = local.repo_name
  license_template       = "MIT"
  vulnerability_alerts   = true
  visibility             = "public"
  description            = "Voice commands from a smart ring: webhook, local whisper.cpp transcription, Claude agent with MCP tools, ntfy notifications"
  topics                 = ["voice-assistant", "mcp", "claude", "whisper", "home-automation", "rust"]
  has_issues             = true
  has_wiki               = false
  auto_init              = true
  delete_branch_on_merge = true

  allow_squash_merge = true
  allow_merge_commit = false
  allow_rebase_merge = false

  branch_protections_v4 = [
    {
      pattern             = "main"
      enforce_admins      = true
      allows_force_pushes = false
      allows_deletions    = false
      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        required_approving_review_count = 0
      }
      # Job names from .github/workflows/ci.yml in lazzurs/ringmaster.
      required_status_checks = {
        strict   = false
        contexts = ["Format", "Clippy", "Test", "Cargo deny", "Docker build"]
      }
    }
  ]
}
