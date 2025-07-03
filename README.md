# Terraform Azure Cloudbase Module

This Terraform module sets up Cloudbase security scanning for Azure environments.

## Key Features

- Automatically creates a unique application name by including the subscription ID (`cloudbase-security-scan-app-<subscription-id>`)
- Sets up necessary permissions for CSPM and CWPP scanning
- Configures federated identity credentials for secure authentication

## Usage

```hcl
module "cloudbase" {
  source = "Levetty/cloudbase/azure"

  directory_id    = "your-azure-directory-id"
  subscription_id = "your-azure-subscription-id"

  federated_identity_credential_security_scan = {
    audiences = [<audience>]
    issuer    = <issuer>
    subject   = <subject>
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

## Outputs

- `cloudbase_app_client_id`: The Client ID of the Cloudbase App
- `subscription_id`: The subscription ID of your Azure Subscription
- `directory_id`: The Directory ID of your Azure Directory
