remote_state {
  backend = "s3"

  config = {
    bucket = "unicornops-terragrunt-state-aireach-production"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "eu-west-1"
  }
}

inputs = merge(
  yamldecode(file(find_in_parent_folders("global.yaml"))),
  yamldecode(file("../cloud.yaml"))
)
