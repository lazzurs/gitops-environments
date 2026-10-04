# Permanent redirect from www.<apex> to https://<apex>, keeping the path
# and query string. Single Redirects only act on proxied traffic, so the
# www record must be proxied (managed in neamh/octodns).
#
# Token permission: Zone > Single Redirect > Edit on the zone.

terraform {
  required_version = ">= 1.5.0"

  # Populated by terragrunt remote_state (cloudflare/lazzurs/root.hcl).
  backend "s3" {}

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.18.0"
    }
  }
}

variable "zone_id" {
  type        = string
  description = "Zone ID of the apex domain."
}

variable "apex" {
  type        = string
  description = "Apex hostname, e.g. lazzurs.com."
}

# Credentials from CLOUDFLARE_API_TOKEN
provider "cloudflare" {}

# The zone's single entry point ruleset for this phase. Further redirects
# for the zone belong in this same resource.
resource "cloudflare_ruleset" "redirects" {
  zone_id     = var.zone_id
  name        = "redirects"
  description = "Redirect rules for ${var.apex}"
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"

  rules = [{
    ref         = "www_to_apex"
    description = "www.${var.apex} -> ${var.apex} (301, keeps path and query)"
    expression  = "(http.host eq \"www.${var.apex}\")"
    action      = "redirect"
    action_parameters = {
      from_value = {
        status_code           = 301
        preserve_query_string = true
        target_url = {
          expression = "concat(\"https://${var.apex}\", http.request.uri.path)"
        }
      }
    }
  }]
}
