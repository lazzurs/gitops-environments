remote_state {
  backend = "s3"

  config = {
    encrypt                              = true
    endpoint                             = "https://s3.unicornops.dev"
    bucket                               = "unicornops-terragrunt-state-aireach-production"
    key                                  = "${path_relative_to_include()}/terraform.tfstate"
    region                               = "us-east-1"
    skip_credentials_validation          = true
    skip_metadata_api_check             = true
    skip_region_validation              = true
    force_path_style                   = true
    skip_bucket_ssencryption            = true
  }
}
