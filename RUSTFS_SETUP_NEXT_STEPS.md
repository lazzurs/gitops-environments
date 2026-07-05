# RustFS S3 Backend - Next Steps

## ✅ Completed

- [x] RustFS deployed with Caddy TLS proxy
- [x] Cloudflare DNS configured (`s3.unicornops.dev`)
- [x] GitHub repository secrets configured
- [x] root.hcl files updated for all environments
- [x] GitHub Actions workflows updated
- [x] Old MinIO secrets removed
- [x] Security verified (IPv4 access blocked)

---

## 🚀 Next Steps

### 1. Create S3 Buckets

Create the required buckets in RustFS for each environment:

```bash
# Set environment variables
export AWS_ACCESS_KEY_ID=UNICORNOPS_TERRAGRUNT
export AWS_SECRET_ACCESS_KEY=5f5a277a5b4dfc7cf863eb43df132268b3c5197ada39fb80def1bee853808427
export AWS_ENDPOINT_URL=https://s3.unicornops.dev
export AWS_REGION=us-east-1

# Create all buckets
aws s3 mb s3://rl-terragrunt-state-cloudflare-unicornops
aws s3 mb s3://rl-terragrunt-state-github
aws s3 mb s3://unicornops-terragrunt-state-aireach-development
aws s3 mb s3://unicornops-terragrunt-state-aireach-production
aws s3 mb s3://unicornops-terragrunt-state-axiom
aws s3 mb s3://unicornops-terragrunt-state-family-chat-development
aws s3 mb s3://unicornops-terragrunt-state-weather-development

# Verify
aws s3 ls
```

**OR** run the provided script:
```bash
chmod +x scripts/create-rustfs-buckets.sh
./scripts/create-rustfs-buckets.sh
```

### 2. Test Connectivity

Verify you can connect to RustFS:

```bash
# Test with AWS CLI
aws s3 ls

# Test with curl (should get AccessDenied without auth)
curl -s https://s3.unicornops.dev/
# Expected: <?xml version="1.0"?><Error><Code>AccessDenied</Code>...
```

### 3. Run a Terragrunt Workflow

Trigger a workflow to test the full pipeline:

**Option A: Push a change**
```bash
# Make a small change and push
echo "test" > /tmp/test.txt
git add . && git commit -m "test: verify rustfs backend"
git push origin main
```

**Option B: Manually trigger a workflow**
- Go to GitHub Actions tab
- Select a workflow (e.g., `terragrunt_plan`)
- Click "Run workflow" → "Run workflow"

### 4. Verify State Storage

After a successful workflow run, verify state is stored in RustFS:

```bash
aws s3 ls s3://rl-terragrunt-state-github/ --recursive
```

---

## 📋 Environment Matrix

| Environment | Bucket | Workflow | Status |
|-------------|--------|----------|--------|
| GitHub | `rl-terragrunt-state-github` | `terragrunt_plan.yml`, `terragrunt_apply.yml` | ⏳ Pending test |
| Cloudflare Unicornops | `rl-terragrunt-state-cloudflare-unicornops` | `cloudflare_unicornops_plan.yml`, `cloudflare_unicornops_apply.yml` | ⏳ Pending test |
| AWS Aireach Development | `unicornops-terragrunt-state-aireach-development` | (via aws/aireach-development) | ⏳ Pending test |
| AWS Aireach Production | `unicornops-terragrunt-state-aireach-production` | (via aws/aireach-production) | ⏳ Pending test |
| Axiom Unicornops | `unicornops-terragrunt-state-axiom` | `axiom_unicornops_plan.yml`, `axiom_unicornops_apply.yml` | ⏳ Pending test |
| AWS Family Chat Dev | `unicornops-terragrunt-state-family-chat-development` | (via aws/family-chat-development) | ⏳ Pending test |
| AWS Weather Dev | `unicornops-terragrunt-state-weather-development` | (via aws/weather-development) | ⏳ Pending test |

---

## 🔧 Troubleshooting

### Connection Issues

If workflows fail with connection errors:

1. **Verify DNS propagation**:
   ```bash
   dig s3.unicornops.dev AAAA
   # Should return: 2606:4700:... (Cloudflare IPs)
   ```

2. **Verify Cloudflare proxy**:
   - Go to Cloudflare Dashboard → DNS
   - Ensure `s3.unicornops.dev` has **Proxy: ENABLED** (orange cloud)
   - SSL/TLS mode: **Full (Strict)**

3. **Check Caddy logs**:
   ```bash
   KUBECONFIG=~/dollarbox-unicornops-internal.kubeconfig kubectl logs -f deployment/caddy -n org-c11161bf-ac00-4300-a253-a085faa9bdd7
   ```

4. **Check RustFS logs**:
   ```bash
   KUBECONFIG=~/dollarbox-unicornops-internal.kubeconfig kubectl logs -f deployment/rustfs-server -n org-c11161bf-ac00-4300-a253-a085faa9bdd7
   ```

### Authentication Issues

If workflows fail with `AccessDenied` or `InvalidAccessKeyId`:

1. **Verify GitHub secrets**:
   ```bash
   gh secret list --repo lazzurs/gitops-environments
   ```
   Should show:
   - `RUSTFS_ACCESS_KEY_ID`
   - `RUSTFS_SECRET_ACCESS_KEY`

2. **Verify secret values**:
   - `RUSTFS_ACCESS_KEY_ID` = `UNICORNOPS_TERRAGRUNT`
   - `RUSTFS_SECRET_ACCESS_KEY` = `5f5a277a5b4dfc7cf863eb43df132268b3c5197ada39fb80def1bee853808427`

3. **Check workflow environment**:
   - Open a workflow run
   - Check the "Configure RustFS credentials" step
   - Verify environment variables are set

### Bucket Issues

If Terragrunt fails with bucket-related errors:

1. **Create buckets manually** (see Step 1 above)
2. **Verify bucket permissions**: RustFS with the given credentials should have full access

---

## 📞 Support

The infrastructure is ready. Next steps:
1. Create the S3 buckets
2. Run a workflow
3. Verify state storage

**Estimated time**: 5-10 minutes

---

*Last updated: 2026-07-05*
