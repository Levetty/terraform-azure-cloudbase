provider "azuread" {
  tenant_id = var.directory_id
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  cspm_role_def_name = "${var.cspm_permissions.custom.role_def_name}_${var.subscription_id}"
  cwpp_role_def_name = "${var.cwpp_permissions.custom.role_def_name}_${var.subscription_id}"
}

# Cloudbase App Module
module "cloudbase-app" {
  source = "./modules/cloudbase-app"

  app_name                      = "cloudbase-security-scan-app-${var.subscription_id}"
  federated_identity_credential = var.federated_identity_credential
}

# Cloudbase Role Setup Module
module "cloudbase-role-setup" {
  source = "./modules/cloudbase-role-setup"

  subscription_id      = var.subscription_id
  service_principal_id = module.cloudbase-app.service_principal_id
  enable_cnapp         = var.enable_cnapp

  cspm_role_def_name = local.cspm_role_def_name
  cspm_permissions = {
    actions          = var.cspm_permissions.custom.permissions.actions
    not_actions      = var.cspm_permissions.custom.permissions.not_actions
    data_actions     = var.cspm_permissions.custom.permissions.data_actions
    not_data_actions = var.cspm_permissions.custom.permissions.not_data_actions
  }

  cwpp_role_def_name = local.cwpp_role_def_name
  cwpp_permissions = {
    actions          = var.cwpp_permissions.custom.permissions.actions
    not_actions      = var.cwpp_permissions.custom.permissions.not_actions
    data_actions     = var.cwpp_permissions.custom.permissions.data_actions
    not_data_actions = var.cwpp_permissions.custom.permissions.not_data_actions
  }
}
