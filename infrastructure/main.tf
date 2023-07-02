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
  host = "https://${symbiosis_cluster.development.endpoint}"

  client_certificate     = symbiosis_cluster.development.certificate
  client_key             = symbiosis_cluster.development.private_key
  cluster_ca_certificate = symbiosis_cluster.development.ca_certificate
}

resource "symbiosis_cluster" "development" {
  name   = "development"
  region = "germany-1"
}

resource "symbiosis_node_pool" "development" {
  cluster = symbiosis_cluster.development.name

  node_type = "general-3"
  quantity  = 3
  name      = "development-pool"
}