#!/bin/bash

# it's safer to do this: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

# set environment variables
touch .env
source .env

# decrypt the secrets.enc.yaml file
sops -d secrets.enc.yaml > secrets.yaml

# create the zarf package
zarf package create --skip-sbom --confirm --no-progress

# deploy the zarf package
zarf package deploy zarf-package-*.tar.zst --confirm --no-progress

# remove the zarf package
rm zarf-package-*.tar.zst

# remove the secrets.yaml file
rm secrets.yaml