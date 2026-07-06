remote_state {
  backend = "s3"

  config = {
    encrypt                              = true
    endpoint                             = "https://s3.unicornops.dev"
    bucket                               = "unicornops-terragrunt-state-axiom"
    key                                  = "${path_relative_to_include()}/terraform.tfstate"
    region                               = "us-east-1"
    skip_credentials_validation          = true
    skip_metadata_api_check             = true
    skip_region_validation              = true
    force_path_style                   = true
    skip_bucket_ssencryption            = true
    skip_requesting_account_id          = true
    access_key                          = "UNICORNOPS_TERRAGRUNT"
    secret_key                          = "5f5a277a5b4dfc7cf863eb43df132268b3c5197ada39fb80def1bee853808427"
  }
}
