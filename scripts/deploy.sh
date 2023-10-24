#!/bin/bash

# it's safer to do this: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

# package helm packages
for package in packages/*; 
do
    helm package $package
    helm push *.tgz "oci://registry.gitlab.com/willswire/cosmology/packages"
    rm *.tgz
done

# create the zarf package
zarf package create --skip-sbom --confirm --no-progress

# deploy the zarf package
zarf package deploy zarf-package-*.tar.zst --confirm --no-progress

# remove the zarf package
rm zarf-package-*.tar.zst