# familychat.dev — dedicated zone for family-chat ephemeral staging.
#
# Deliberately a separate registrable domain (Cloudflare subdomain zones are
# Enterprise-only): the staging CI token is scoped to this zone and cannot
# touch the production safechat.family zone. See family-chat's
# docs/staging-environment.md for the environment this serves.
#
# After first apply: point the registrar's nameservers at the name_servers
# output, then copy zone_id into the family-chat repo's `staging` GitHub
# environment as CLOUDFLARE_ZONE_ID.

include "root" {
  path = find_in_parent_folders("root.hcl")
}

# The zone is defined inline via the generate blocks below; the self-referencing
# source is required for terragrunt run-all to discover this module.
terraform {
  source = "."
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {}
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}
EOF
}

generate "main" {
  path      = "main.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "cloudflare_account_id" {
  type = string
}

variable "zone_name" {
  type = string
}

resource "cloudflare_zone" "this" {
  account_id = var.cloudflare_account_id
  zone       = var.zone_name
  plan       = "free"
}

resource "cloudflare_zone_settings_override" "this" {
  zone_id = cloudflare_zone.this.id

  settings {
    always_use_https = "on"
    ssl              = "strict"
  }
}

output "zone_id" {
  value = cloudflare_zone.this.id
}

output "name_servers" {
  value = cloudflare_zone.this.name_servers
}
EOF
}

inputs = {
  zone_name = "familychat.dev"
}
