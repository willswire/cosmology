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
    vm_size    = "Standard_B4ms"
    enable_auto_scaling = true
    min_count = 1
    max_count = 3
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "gpu_pool" {
  name                  = "gpupool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cosmology.id
  vm_size               = "Standard_NC4as_T4_v3"
  node_taints           = ["sku=gpu:NoSchedule"]
  node_count            = 1
  node_labels = {
    "node_type" = "gpu"
  }
}
