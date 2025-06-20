variable "always_recreate_cloudbase_app" {
  description = "Always recreate the Cloudbase app with a unique timestamp suffix"
  type        = bool
  default     = false
}

variable "federated_identity_credential" {
  description = "Federated identity credential for security scan"
  type = object({
    issuer    = string
    audiences = list(string)
    subject   = string
  })
}