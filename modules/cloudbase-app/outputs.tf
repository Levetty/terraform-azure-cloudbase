output "application_client_id" {
  description = "The client ID of the Azure AD application"
  value       = azuread_application.cloudbase_security_scan_app.client_id
}

output "service_principal_id" {
  description = "The object ID of the service principal"
  value       = azuread_service_principal.cloudbase_security_scan_sp.object_id
}

output "service_principal_client_id" {
  description = "The client ID of the service principal"
  value       = azuread_service_principal.cloudbase_security_scan_sp.client_id
}
