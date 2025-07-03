# Data sources
data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}

# Local variables
locals {
  now_utc = formatdate("YYYYMMDDhhmm", timestamp())
  # Microsoft Graph API permissions (excluding Organization.Read.All)
  msgraph_resource_access = {
    "User.Read.All" = {
      id   = azuread_service_principal.msgraph.app_role_ids["User.Read.All"]
      type = "Role"
    }
    "Policy.Read.All" = {
      id   = azuread_service_principal.msgraph.app_role_ids["Policy.Read.All"]
      type = "Role"
    }
    "AuditLog.Read.All" = {
      id   = azuread_service_principal.msgraph.app_role_ids["AuditLog.Read.All"]
      type = "Role"
    }
    "UserAuthenticationMethod.Read.All" = {
      id   = azuread_service_principal.msgraph.app_role_ids["UserAuthenticationMethod.Read.All"]
      type = "Role"
    }
  }
}

# Azure AD Application
resource "azuread_application" "cloudbase_security_scan_app" {
  display_name = "${var.app_name}-${local.now_utc}"

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    dynamic "resource_access" {
      for_each = local.msgraph_resource_access
      content {
        id   = resource_access.value.id
        type = resource_access.value.type
      }
    }
  }

  lifecycle {
    ignore_changes = [display_name]
  }
}

# Service Principal
resource "azuread_service_principal" "cloudbase_security_scan_sp" {
  description = "Cloudbase Security Scan App created by Terraform"
  client_id   = azuread_application.cloudbase_security_scan_app.client_id
}

# App Role Assignments (Admin Consent)
resource "azuread_app_role_assignment" "admin_consent" {
  for_each            = local.msgraph_resource_access
  app_role_id         = each.value.id
  principal_object_id = azuread_service_principal.cloudbase_security_scan_sp.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

# Directory Role Assignment - Security Reader
resource "azuread_directory_role" "security_reader" {
  display_name = "Security Reader"
}

resource "azuread_directory_role_assignment" "security_reader" {
  role_id             = azuread_directory_role.security_reader.template_id
  principal_object_id = azuread_service_principal.cloudbase_security_scan_sp.object_id
}

# Federated Identity Credential for Security Scan
resource "azuread_application_federated_identity_credential" "security_scan" {
  application_id = azuread_application.cloudbase_security_scan_app.id
  display_name   = "cloudbase-security-scan-credential"

  issuer    = var.federated_identity_credential.issuer
  audiences = var.federated_identity_credential.audiences
  subject   = var.federated_identity_credential.subject
}
