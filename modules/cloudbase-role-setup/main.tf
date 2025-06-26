locals {
  now_utc = formatdate("YYYYMMDDhhmm", timestamp())
  random  = var.use_random_suffix ? "-${local.now_utc}" : ""
}

# CSPM Role Definition
resource "azurerm_role_definition" "cspm" {
  name        = "${var.cspm_role_def_name}${local.random}"
  scope       = "/subscriptions/${var.subscription_id}"
  description = "Custom role for Cloudbase CSPM"

  permissions {
    actions          = var.cspm_permissions.actions
    not_actions      = var.cspm_permissions.not_actions
    data_actions     = var.cspm_permissions.data_actions
    not_data_actions = var.cspm_permissions.not_data_actions
  }

  assignable_scopes = ["/subscriptions/${var.subscription_id}"]

  lifecycle {
    ignore_changes  = [assignable_scopes, name, permissions]
    prevent_destroy = true
  }
}

# CWPP Role Definition (if enabled)
resource "azurerm_role_definition" "cwpp" {
  count       = var.enable_cnapp ? 1 : 0
  name        = "${var.cwpp_role_def_name}${local.random}"
  scope       = "/subscriptions/${var.subscription_id}"
  description = "Custom role for Cloudbase CWPP"

  permissions {
    actions          = var.cwpp_permissions.actions
    not_actions      = var.cwpp_permissions.not_actions
    data_actions     = var.cwpp_permissions.data_actions
    not_data_actions = var.cwpp_permissions.not_data_actions
  }

  assignable_scopes = ["/subscriptions/${var.subscription_id}"]

  lifecycle {
    ignore_changes  = [assignable_scopes, name, permissions]
    prevent_destroy = true
  }
}

# CSPM Role Assignment
resource "azurerm_role_assignment" "cspm" {
  scope                            = "/subscriptions/${var.subscription_id}"
  role_definition_id               = azurerm_role_definition.cspm.role_definition_resource_id
  principal_id                     = var.service_principal_id
  skip_service_principal_aad_check = true
}

# CWPP Role Assignment (if enabled)
resource "azurerm_role_assignment" "cwpp" {
  count                            = var.enable_cnapp ? 1 : 0
  scope                            = "/subscriptions/${var.subscription_id}"
  role_definition_id               = azurerm_role_definition.cwpp[0].role_definition_resource_id
  principal_id                     = var.service_principal_id
  skip_service_principal_aad_check = true
}
