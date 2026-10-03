include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/rustfs/modules/state-buckets"
}

# State buckets on s3.lazzurs.net created by this stack. Buckets that
# predate it (e.g. rl-terragrunt-state-github) are not managed here yet;
# importing them needs a careful plan first.
inputs = {
  s3_endpoint = "https://s3.lazzurs.net"
  s3_region   = "eu-west-1"

  buckets = [
    # cloudflare/lazzurs (lazzurs.org Cloudflare account)
    "rl-terragrunt-state-cloudflare-lazzurs",
  ]
}
