variable "app_name" {
  description = "Name of the app"
  type        = string
}

variable "federated_identity_credential" {
  description = "Federated identity credential for security scan"
  type = object({
    issuer    = string
    audiences = list(string)
    subject   = string
  })
}
