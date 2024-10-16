# gitops-environments
Repo for control of all of my cloud usage using Terragrunt to control.

This is intended as an example repo to show how to use Terragrunt to manage multiple clouds and environments in one repository giving an overview of the entire cloud usage for an organization.

## Structure

### Directories

The structure of this repository is as follows:

```
clouds <- each cloud provider is at the top level
- accounts <- Next level down is the account
  - environments <- Next level down is the environment
    - modules <- Next level down is deployments in the environment
      - terragrunt.hcl <- Terragrunt configuration
```

### Inheritance

Inheritance is done by using the `terragrunt.hcl` file in each cloud. This file is used to define the configuration for the default includes in that cloud and it is expected to use the following structure:

```
global.yaml <- Global configuration for all environments, cloud providers, and accounts
clouds/cloud.yaml <- Configuration for the cloud provider
clouds/accounts/account.yaml <- Configuration for the account
```
