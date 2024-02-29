terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.72.0"
    }
  }

  backend "http" {}
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}