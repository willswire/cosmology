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

resource "azurerm_resource_group" "cosmology" {
  name     = "cosmology"
  location = "South Central US"
}

resource "azurerm_kubernetes_cluster" "cosmology" {
  name                = "${azurerm_resource_group.cosmology.name}-cluster"
  resource_group_name = azurerm_resource_group.cosmology.name
  dns_prefix          = azurerm_resource_group.cosmology.name
  location            = azurerm_resource_group.cosmology.location

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_B4ms"
  }

  identity {
    type = "SystemAssigned"
  }
}
