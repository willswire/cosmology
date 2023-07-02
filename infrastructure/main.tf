terraform {
  required_providers {
    symbiosis = {
      source  = "symbiosis-cloud/symbiosis"
      version = "0.5.6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
  }
  backend "http" {}
}

provider "symbiosis" {
  api_key = var.symbiosis_api_key
}

provider "kubernetes" {
  host = "https://${symbiosis_cluster.cosmology.endpoint}"

  client_certificate     = symbiosis_cluster.cosmology.certificate
  client_key             = symbiosis_cluster.cosmology.private_key
  cluster_ca_certificate = symbiosis_cluster.cosmology.ca_certificate
}

resource "symbiosis_cluster" "cosmology" {
  name   = "cosmology"
  region = "germany-1"
}

resource "symbiosis_node_pool" "cosmology" {
  cluster = symbiosis_cluster.cosmology.name

  node_type = "general-3"
  quantity  = 4
  name      = "cosmology-pool"
}