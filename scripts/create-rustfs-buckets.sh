#!/bin/bash
# Create RustFS Buckets for Terragrunt State Storage
# This script creates all the S3 buckets needed for the gitops-environments repo

set -euo pipefail

export AWS_ACCESS_KEY_ID="UNICORNOPS_TERRAGRUNT"
export AWS_SECRET_ACCESS_KEY="5f5a277a5b4dfc7cf863eb43df132268b3c5197ada39fb80def1bee853808427"
export AWS_ENDPOINT_URL="https://s3.unicornops.dev"
export AWS_REGION="us-east-1"

BUCKETS=(
  "rl-terragrunt-state-cloudflare-unicornops"
  "rl-terragrunt-state-github"
  "unicornops-terragrunt-state-aireach-development"
  "unicornops-terragrunt-state-aireach-production"
  "unicornops-terragrunt-state-axiom"
  "unicornops-terragrunt-state-family-chat-development"
  "unicornops-terragrunt-state-weather-development"
)

echo "Creating RustFS buckets for Terragrunt state storage..."
echo ""

for bucket in "${BUCKETS[@]}"; do
  echo "Creating bucket: ${bucket}"
  if aws s3 mb "s3://${bucket}" 2>&1; then
    echo "  ✅ Created"
  else
    echo "  ⚠️  May already exist or failed"
  fi
done

echo ""
echo "Verifying buckets..."
aws s3 ls 2>&1

echo ""
echo "✅ Bucket creation complete!"
