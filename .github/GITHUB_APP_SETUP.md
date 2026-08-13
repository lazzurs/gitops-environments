# GitHub App Setup for gitops-environments

This repository has been reconfigured to use a **GitHub App** instead of a Personal Access Token (PAT) for GitHub API authentication. This provides better security and auditability.

---

## Required GitHub Repository Secrets

You need to create **3 new secrets** in your GitHub repository (`lazzurs/gitops-environments` or `unicornops/gitops-environments`):

### 1. GITHUB_APP_ID
**Value**: Your GitHub App ID (e.g., `123456`)
**How to get it**: After creating the GitHub App, this is shown in the app settings URL
**Example dummy value**: `CHANGE_ME_GITHUB_APP_ID`

### 2. GITHUB_APP_INSTALLATION_ID
**Value**: The installation ID of the app on your organization (e.g., `789012`)
**How to get it**: Go to https://github.com/organizations/unicornops/settings/installations, click on your app, the URL will contain the installation ID
**Example dummy value**: `CHANGE_ME_GITHUB_APP_INSTALLATION_ID`

### 3. GITHUB_APP_PRIVATE_KEY
**Value**: The private key in PEM format (starts with `-----BEGIN RSA PRIVATE KEY-----`)
**How to get it**: After creating the GitHub App, click "Generate a private key" in the app settings
**Example dummy value**:
```
-----BEGIN RSA PRIVATE KEY-----
CHANGE_ME_PRIVATE_KEY_CONTENT
-----END RSA PRIVATE KEY-----
```

---

## Step-by-Step: Create the GitHub App

### Step 1: Create the App in the unicornops Organization

1. Go to: [https://github.com/organizations/unicornops/settings/apps](https://github.com/organizations/unicornops/settings/apps)
2. Click **"New GitHub App"**
3. Configure the app:
   - **GitHub App name**: `gitops-environments-manager`
   - **Description**: `Manages repositories for gitops-environments infrastructure`
   - **Homepage URL**: `https://github.com/unicornops/gitops-environments`

### Step 2: Set Permissions

Under **Repository permissions**:
- ✅ **Contents**: Read and Write
- ✅ **Metadata**: Read-only
- ✅ **Pull requests**: Read and Write
- ✅ **Issues**: Read and Write
- ✅ **Commit statuses**: Read and Write

Under **Organization permissions**:
- ✅ **Members**: Read-only (optional)
- ✅ **Repository administration**: Read and Write (required for repo creation)

### Step 3: Generate Private Key

After creating the app:
1. Scroll down to **"Private keys"** section
2. Click **"Generate a private key"**
3. Save the `.pem` file (you'll need its contents)

### Step 4: Install the App

1. In the app settings, click **"Install App"**
2. Select **"Only select repositories"**
3. Choose the repositories this app should manage (or install on all)
4. Click **"Install"**
5. **Note the Installation ID** from the URL (e.g., `https://github.com/organizations/unicornops/settings/installations/789012`)

### Step 5: Add Secrets to Your Repository

In your repository (`lazzurs/gitops-environments` or `unicornops/gitops-environments`):

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **"New repository secret"** three times:

   **First secret:**
   - Name: `GITHUB_APP_ID`
   - Value: `123456` (your actual app ID)

   **Second secret:**
   - Name: `GITHUB_APP_INSTALLATION_ID`
   - Value: `789012` (your actual installation ID)

   **Third secret:**
   - Name: `GITHUB_APP_PRIVATE_KEY`
   - Value: The entire contents of your `.pem` file

### Step 6: Remove Old Secret (Optional)

You can now safely **delete** the `TERRAGRUNT_GITHUB_API_TOKEN` secret from your repository, as it's no longer used.

---

## Updated Workflows

The following 5 workflow files have been updated to use the GitHub App:

1. `.github/workflows/cloudflare_unicornops_plan.yml`
2. `.github/workflows/cloudflare_unicornops_apply.yml`
3. `.github/workflows/terragrunt_plan.yml`
4. `.github/workflows/terragrunt_apply.yml`
5. `.github/workflows/test_rustfs.yml`

Each workflow now includes a **"Generate GitHub App Installation Token"** step that:
1. Creates a JWT signed with the app's private key
2. Exchanges the JWT for a short-lived installation access token
3. Passes the token to Terragrunt as `GITHUB_TOKEN`

---

## Benefits of This Approach

| Aspect | PAT | GitHub App |
|--------|-----|------------|
| **Security** | User credentials | Machine identity |
| **Lifespan** | Long-lived | Short-lived tokens (auto-expire) |
| **Permissions** | Broad (all user access) | Granular (only what's granted) |
| **Auditability** | Under user account | Under app identity |
| **Token leakage** | High risk | Limited risk |

---

## Testing

After setting up the secrets, trigger a workflow manually to test:

```bash
gh workflow run ".github/workflows/test_rustfs.yml"
```

The workflow should complete successfully, and you should see the GitHub App token generation step complete without errors.

---

## Troubleshooting

### JWT Signature Failed
If you see `"signature verification failed"`:
- Verify the `GITHUB_APP_PRIVATE_KEY` is correctly formatted (includes `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----`)
- Ensure there are no extra spaces or newlines

### Installation Token Failed
If you see `"Not Found"` when getting the installation token:
- Verify `GITHUB_APP_ID` is correct
- Verify `GITHUB_APP_INSTALLATION_ID` is correct
- Ensure the app is installed on the repository/organization

### Permission Denied
If you see `"Permission denied"` errors:
- Verify the app has the required repository permissions
- Ensure the app is installed on the correct organization/repository
