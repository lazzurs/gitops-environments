# RustFS S3 Backend Secrets Configuration

This repository uses **RustFS** (self-hosted S3-compatible storage) for Terragrunt remote state management.

## Required GitHub Repository Secrets

Set the following secrets in your GitHub repository under **Settings → Secrets → Actions**:

### RustFS Credentials
| Secret Name | Value | Description |
|-------------|-------|-------------|
| `RUSTFS_ACCESS_KEY_ID` | `UNICORNOPS_TERRAGRUNT` | Access key for RustFS authentication |
| `RUSTFS_SECRET_ACCESS_KEY` | `5f5a277a5b4dfc7cf863eb43df132268b3c5197ada39fb80def1bee853808427` | Secret key for RustFS authentication |

### Other Required Secrets
| Secret Name | Description |
|-------------|-------------|
| `TERRAGRUNT_GITHUB_API_TOKEN` | GitHub Personal Access Token with repo permissions |

## RustFS Configuration Details

- **Endpoint**: `https://s3.unicornops.dev`
- **Region**: `us-east-1`
- **Bucket Prefix**: `unicornops-terragrunt-state-`
- **Protocol**: HTTPS with Cloudflare TLS termination

## Environment Variables Used in Workflows

The following environment variables are automatically set in GitHub Actions workflows:

```yaml
env:
  AWS_ACCESS_KEY_ID: ${{ secrets.RUSTFS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.RUSTFS_SECRET_ACCESS_KEY }}
  AWS_ENDPOINT_URL: https://s3.unicornops.dev
  AWS_REGION: us-east-1
```

## Terragrunt Backend Configuration

All `root.hcl` files have been updated to use the RustFS endpoint:

```hcl
remote_state {
  backend = "s3"

  config = {
    encrypt                              = true
    endpoint                             = "https://s3.unicornops.dev"
    bucket                               = "unicornops-terragrunt-state-<environment>"
    key                                  = "${path_relative_to_include()}/terraform.tfstate"
    region                               = "us-east-1"
    skip_credentials_validation          = true
    skip_metadata_api_check             = true
    skip_region_validation              = true
    force_path_style                   = true
  }
}
```

**Note**: The `access_key` and `secret_key` are NOT in the root.hcl files. They are provided via environment variables in the workflows for security.

## Testing the Configuration

Once the secrets are set, you can test the S3 backend with:

```bash
# Set environment variables
export AWS_ACCESS_KEY_ID=UNICORNOPS_TERRAGRUNT
export AWS_SECRET_ACCESS_KEY=5f5a277a5b4dfc7cf863eb43df132268b3c5197ada39fb80def1bee853808427
export AWS_ENDPOINT_URL=https://s3.unicornops.dev
export AWS_REGION=us-east-1

# Test with AWS CLI
aws s3 ls s3://unicornops-terragrunt-state-aireach-development/
```

## Infrastructure Details

- **RustFS Pod**: Running in dollarbox Kubernetes cluster
- **Caddy Reverse Proxy**: Terminus TLS with Cloudflare Origin Certificate
- **Cloudflare**: Proxy enabled with Full (Strict) SSL mode
- **DNS**: `s3.unicornops.dev` → `2a01:4f8:fff0:18b:1000::90` (via Cloudflare proxy)
