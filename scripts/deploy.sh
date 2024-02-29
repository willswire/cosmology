#!/bin/bash

# it's safer to do this: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -exo pipefail

# Check if CI_COMMIT_BRANCH is set and not empty
if [ -z "$CI_COMMIT_BRANCH" ]; then
  # If CI_COMMIT_BRANCH is not set, determine the current branch using git
  TAG=$(git branch --show-current)

  # If the current branch is 'main', set TAG to an empty string
  if [ "$TAG" == "main" ]; then
    TAG=''
  fi
else
  # If CI_COMMIT_BRANCH is set, use it as the tag
  TAG=$CI_COMMIT_BRANCH
fi

# Export the TAG variable for subsequent steps
export TAG

# package helm packages
for package in packages/*; 
do
    export HELM_PRE_TAG=$(yq '.version' $package/Chart.yaml)
    yq e -i '.version += "-" + env(TAG)' $package/Chart.yaml
    helm package $package
    helm push *.tgz "oci://registry.gitlab.com/willswire/cosmology/packages"
    yq e -i '.version = env(HELM_PRE_TAG)' $package/Chart.yaml
    rm *.tgz
done

# decrypt secrets if they don't exist yet
if [ ! -f secrets.yaml ];
then
	sops -d secrets.enc.yaml > secrets.yaml
fi

# create the zarf package
zarf package create --skip-sbom --confirm --no-progress

# deploy the zarf package
zarf package deploy zarf-package-*.tar.zst --confirm --no-progress

# remove the zarf package
rm zarf-package-*.tar.zst