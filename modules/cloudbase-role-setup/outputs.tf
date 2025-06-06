output "cspm_role_definition_id" {
  description = "The ID of the CSPM role definition"
  value       = azurerm_role_definition.cspm.role_definition_resource_id
}

output "cwpp_role_definition_id" {
  description = "The ID of the CWPP role definition"
  value       = var.enable_cnapp ? azurerm_role_definition.cwpp[0].role_definition_resource_id : null
}

output "cspm_role_assignment_id" {
  description = "The ID of the CSPM role assignment"
  value       = azurerm_role_assignment.cspm.id
}

output "cwpp_role_assignment_id" {
  description = "The ID of the CWPP role assignment"
  value       = var.enable_cnapp ? azurerm_role_assignment.cwpp[0].id : null
}