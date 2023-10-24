#!/bin/bash

# it's safer to do this: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

# create infrastructure
cd infrastructure
terraform apply -auto-approve

# set kube context
az aks get-credentials --resource-group cosmology --name cosmology-cluster --overwrite-existing