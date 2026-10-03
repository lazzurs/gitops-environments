# lazzurs.org Cloudflare account. State lives on s3.lazzurs.net in a bucket
# created by rustfs/lazzurs/state-buckets.
remote_state {
  backend = "s3"

  config = {
    encrypt                     = false
    bucket                      = "rl-terragrunt-state-cloudflare-lazzurs"
    key                         = "${path_relative_to_include()}/terraform.tfstate"
    region                      = "eu-west-1"
    endpoint                    = "https://s3.lazzurs.net"
    force_path_style            = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}

inputs = yamldecode(file("${get_parent_terragrunt_dir()}/cloud.yaml"))
