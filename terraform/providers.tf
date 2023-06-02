provider "azurerm" {
  features {}
}

terraform {
  required_version = ">= 1.3.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.40.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = ">= 1.5.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.7.0"
    }
  }
}
