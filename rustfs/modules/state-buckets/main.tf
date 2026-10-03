# Terraform state buckets on a RustFS server.
#
# rustfs_bucket comes from the RustFS provider. Its v0.0.8 release has no
# versioning resource, so versioning is set through the S3 API with the
# AWS provider pointed at the same server. State buckets must be versioned
# so every write can be audited and rolled back.

terraform {
  required_version = ">= 1.5.0"

  # Populated by terragrunt remote_state (rustfs/root.hcl).
  backend "s3" {}

  required_providers {
    rustfs = {
      source  = "weinmann-emt/rustfs"
      version = "0.0.8"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"
    }
  }
}

variable "s3_endpoint" {
  type        = string
  description = "HTTPS URL of the RustFS S3 endpoint, e.g. https://s3.lazzurs.net"
}

variable "s3_region" {
  type        = string
  description = "Region used to sign S3 API requests for versioning."
}

variable "buckets" {
  type        = set(string)
  description = "State buckets to create and version."
}

# Endpoint and credentials come from RUSTFS_ENDPOINT / RUSTFS_USER /
# RUSTFS_SECRET in the environment.
provider "rustfs" {
  ssl = true
}

provider "aws" {
  region                      = var.s3_region
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = var.s3_endpoint
  }
}

resource "rustfs_bucket" "state" {
  for_each = var.buckets

  name = each.value

  # A state bucket going away takes every stack's state with it
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "state" {
  for_each = rustfs_bucket.state

  bucket = each.value.name

  versioning_configuration {
    status = "Enabled"
  }
}

output "buckets" {
  value = sort([for b in rustfs_bucket.state : b.name])
}
