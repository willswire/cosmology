# 🌌 Cosmology

Working with Platform One's [Big Bang](https://repo1.dso.mil/big-bang/bigbang) can be tricky. Especially when developing on a shared cluster with other team members. This project provides a playground for several of my personal "quests" in exploring novel functionality and features within Big Bang. In order to test my ideas and experiment on the cheap, I use the following technologies:

- [OpenTofu](https://opentofu.org) to dynamically provision infrastructure
- [Zarf](https://github.com/defenseunicorns/zarf) to package my configurations and deploy them

## 🚀 Exploration missions

The following list contains ideas I have explored thusfar within this project:

- leveraging [Cloudflare Zero Trust](https://willswire.com/cosmology-mtls) for secure access to Big Bang apps and services
- switching out Iron Bank images for [Chainguard](https://www.chainguard.dev) where possible
- developing and deploying my own custom packages via the Wrapper as described [here](https://docs-bigbang.dso.mil/latest/docs/guides/deployment-scenarios/extra-package-deployment/)

## 🧭 Deployment instructions

1. Clone this project
2. Ensure you have the following installed:
    - [OpenTofu](https://opentofu.org/docs/intro/install/)
    - [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
    - [yq](https://github.com/mikefarah/yq)
    - [Helm CLI](https://helm.sh/docs/intro/install/)
    - [sops](https://github.com/getsops/sops)
    - [Zarf CLI](https://docs.zarf.dev/docs/getting-started/installing-zarf)
3. Source `cosmos.sh`
4. Start exploring! ✨