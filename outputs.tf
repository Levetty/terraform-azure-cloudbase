output "cloudbase_app_client_id" {
  description = "The Client ID of the Cloudbase App"
  value       = module.cloudbase-app.application_client_id
}

output "subscription_id" {
  description = "The subscription ID of your Azure Subscription"
  value       = var.subscription_id
}

output "directory_id" {
  description = "The Directory ID of your Azure Directory"
  value       = var.directory_id
}

output "cspm_role_def_name" {
  value = local.cspm_role_def_name
}

output "cwpp_role_def_name" {
  value = local.cwpp_role_def_name
}
