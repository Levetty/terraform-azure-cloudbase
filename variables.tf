###############################################################################
# Required
###############################################################################
variable "directory_id" {
  description = "(required) The Azure Entra ID directory ID"
  type        = string
}

variable "subscription_id" {
  description = "(required) The Azure subscription ID where security scanning will be performed"
  type        = string
}

variable "federated_identity_credential" {
  type = object({
    audiences = list(string)
    issuer    = string
    subject   = string
  })
  description = "(required) Federated Identity Credential for establishing a connection between your Azure environment and Cloudbase. Please provide the values supplied by Cloudbase for security scan."
}

###############################################################################
# Optional 
###############################################################################
variable "enable_cnapp" {
  default     = true
  description = "(optional) Enable CNAPP functions. If it is true, both CSPM and CWPP role definitions will be created and assigned for comprehensive security scanning."
  type        = bool
}

variable "cspm_permissions" {
  description = <<EOT
  (optional) Specify the permissions for the CSPM role.
  EOT

  type = object({
    custom = object({
      role_def_name = string
      permissions = object({
        actions          = list(string)
        not_actions      = list(string)
        data_actions     = list(string)
        not_data_actions = list(string)
      })
    })
    built_in = list(object({
      name        = string
      role_def_id = string
    }))
  })

  default = {
    custom = {
      role_def_name = "CloudbaseCSPMRoleV20240906"
      permissions = {
        actions = [
          "*/read",
          "Microsoft.IoTSecurity/defenderSettings/downloadManagerActivation/action",
          "Microsoft.IoTSecurity/defenderSettings/packageDownloads/action",
          "Microsoft.Security/iotDefenderSettings/downloadManagerActivation/action",
          "Microsoft.Security/iotDefenderSettings/packageDownloads/action",
          "Microsoft.Security/iotSensors/downloadResetPassword/action",
        ],
        not_actions = [],
        data_actions = [
          "Microsoft.KeyVault/vaults/*/read",
          "Microsoft.KeyVault/vaults/secrets/readMetadata/action",
          "*/metadata/read"
        ],
        not_data_actions = []
      }
    }
    built_in = []
  }
}

variable "cwpp_permissions" {
  description = <<EOT
  (optional) Specify the permissions for the CWPP role.
  EOT

  type = object({
    custom = object({
      role_def_name = string
      permissions = object({
        actions          = list(string)
        not_actions      = list(string)
        data_actions     = list(string)
        not_data_actions = list(string)
      })
    })
    built_in = list(object({
      name        = string
      role_def_id = string
    }))
  })

  default = {
    custom = {
      role_def_name = "CloudbaseCWPPRoleV20240906"
      permissions = {
        actions = [
          "Microsoft.Resources/subscriptions/resourceGroups/write",
          "Microsoft.Resources/subscriptions/resourceGroups/delete",
          "Microsoft.Compute/snapshots/write",
          "Microsoft.Compute/snapshots/delete",
          "Microsoft.Compute/disks/beginGetAccess/action",
          "Microsoft.Compute/disks/endGetAccess/action",
          "Microsoft.Compute/snapshots/beginGetAccess/action",
          "Microsoft.Compute/snapshots/endGetAccess/action",
          "Microsoft.Storage/storageAccounts/listkeys/action",
          "Microsoft.Web/sites/config/list/action",
          "Microsoft.Web/sites/publishxml/Action"
        ],
        not_actions      = [],
        data_actions     = [],
        not_data_actions = []
      }
    }
    built_in = []
  }
}

variable "always_recreate_cloudbase_app" {
  description = "(optional) Controls whether to always recreate the cloudbase_app. When set to true, the application will be recreated (with a new name) even if it already exists. Set to false if you are using remote Terraform state."
  type        = bool
  default     = false
}

variable "use_random_suffix" {
  description = "(optional) Whether to append a random suffix to role definition names. This helps avoid conflicts when recreating roles."
  type        = bool
  default     = false
}
