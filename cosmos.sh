#!/bin/bash

create() {
    # create infrastructure
    pushd infrastructure
    tofu apply -auto-approve

    # set kube context
    az aks get-credentials --resource-group cosmology --name cosmology-cluster --overwrite-existing

    # return
    popd
}

deploy() {
    # create and push helm packages
    pushd packages
    for package in *; do
        helm package $package
        helm push *$package*.tgz "oci://registry.gitlab.com/willswire/cosmology/charts"
        rm *$package*.tgz
    done
    popd

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
}

destroy() {
    # destroy infrastructure
    pushd infrastructure
    tofu destroy -auto-approve

    # return
    popd
}

cosmos() {
    case "$1" in
        create)
            create
            ;;
        deploy)
            deploy
            ;;
        destroy)
            destroy
            ;;
        *)
            echo "Usage: cosmos {create|deploy|destroy}"
            return 1
            ;;
    esac
}