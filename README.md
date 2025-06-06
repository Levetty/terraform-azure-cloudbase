# Terraform Azure Cloudbase Module

This Terraform module sets up Cloudbase security scanning for Azure environments.

## Usage

```hcl
module "cloudbase" {
  source = "Levetty/cloudbase/azure"

  directory_id    = "your-azure-directory-id"
  subscription_id = "your-azure-subscription-id"

  federated_identity_credential_security_scan = {
    audiences = ["api://AzureADTokenExchange"]
    issuer    = "https://token.actions.githubusercontent.com"
    subject   = "repo:your-org/your-repo:ref:refs/heads/main"
  }
}
```

## Required Variables

- `directory_id`: The Azure Entra ID directory ID
- `subscription_id`: The Azure subscription ID where security scanning will be performed
- `federated_identity_credential_security_scan`: Federated Identity Credential for establishing a connection between your Azure environment and Cloudbase

## Optional Variables

- `enable_cnapp`: Enable CNAPP functions (default: true)
- `cspm_permissions`: Specify the permissions for the CSPM role
- `cwpp_permissions`: Specify the permissions for the CWPP role
- `always_recreate_cloudbase_app`: Controls whether to always recreate the cloudbase_app (default: false)
- `use_random_suffix`: Whether to append a random suffix to role definition names (default: true)

## Outputs

- `cloudbase_app_client_id`: The Client ID of the Cloudbase App
- `subscription_id`: The subscription ID of your Azure Subscription
- `directory_id`: The Directory ID of your Azure Directory
