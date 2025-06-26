variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "service_principal_id" {
  description = "Service Principal Object ID to assign roles to"
  type        = string
}

variable "enable_cnapp" {
  description = "Enable CNAPP (CWPP) role and permissions"
  type        = bool
  default     = false
}

variable "cspm_role_def_name" {
  description = "Name for the CSPM role definition"
  type        = string
}

variable "cspm_permissions" {
  description = "Permissions for CSPM role"
  type = object({
    actions          = list(string)
    not_actions      = list(string)
    data_actions     = list(string)
    not_data_actions = list(string)
  })
}

variable "cwpp_role_def_name" {
  description = "Name for the CWPP role definition"
  type        = string
}

variable "cwpp_permissions" {
  description = "Permissions for CWPP role"
  type = object({
    actions          = list(string)
    not_actions      = list(string)
    data_actions     = list(string)
    not_data_actions = list(string)
  })
}
