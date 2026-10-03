# RustFS (s3.lazzurs.net) managed with the weinmann-emt/rustfs provider.
#
# This stack's own state can't live in a bucket it creates, so it sits
# under a rustfs/ key prefix in the long-standing rl-terragrunt-state-github
# bucket. Moving it to the other RustFS server (s3.unicornops.dev) would
# remove the self-hosting entirely.
remote_state {
  backend = "s3"

  config = {
    encrypt                     = false
    bucket                      = "rl-terragrunt-state-github"
    key                         = "rustfs/${path_relative_to_include()}/terraform.tfstate"
    region                      = "eu-west-1"
    endpoint                    = "https://s3.lazzurs.net"
    force_path_style            = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}
