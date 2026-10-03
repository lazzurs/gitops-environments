remote_state {
  backend = "s3"

  config = {
    encrypt                     = false
    bucket                      = "rl-terragrunt-state-github"
    key                         = "${path_relative_to_include()}/terraform.tfstate"
    region                      = "eu-west-1"
    endpoint                    = "https://s3.lazzurs.net"
    force_path_style            = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}
