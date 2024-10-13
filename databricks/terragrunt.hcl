remote_state {
  backend = "s3"
  //disable_init = true

  config = {
    encrypt = true
    bucket  = "rl-terragrunt-state-databricks"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "eu-west-1"
  }
}

inputs = merge(
  yamldecode(file(find_in_parent_folders("global.yaml"))),
  yamldecode(file("cloud.yaml"))
)
