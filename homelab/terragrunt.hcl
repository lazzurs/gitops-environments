remote_state {
  backend = "s3"
  //disable_init = true

  config = {
    encrypt                            = false
    endpoint                           = "https://s3.lazzurs.net"
    bucket                             = "rl-terragrunt-state-homelab"
    key                                = "${path_relative_to_include()}/terraform.tfstate"
    region                             = "eu-west-1"
    disable_aws_client_checksums       = true
    skip_bucket_ssencryption           = true
    skip_bucket_public_access_blocking = true
    skip_bucket_enforced_tls           = true
    skip_bucket_root_access            = true
    skip_credentials_validation        = true
    force_path_style                   = true
  }
}

inputs = merge(
  yamldecode(file(find_in_parent_folders("global.yaml"))),
  yamldecode(file("cloud.yaml"))
)
