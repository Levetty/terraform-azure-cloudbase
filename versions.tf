terraform {
  required_version = "~> 1.11"
  
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.3"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }
  }
}