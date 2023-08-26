# 🌌 Cosmology

Working with Big Bang can be tricky. Especially when developing on a shared cluster with other team members. This project provides a playground for several of my personal "quests" in exploring novel functionality and features within Big Bang. In order to test my ideas and experiment on the cheap, I use the following technologies:

- [Terraform](https://www.terraform.io) to provision [infrastructure](/infrastructure/README.md)
- [Zarf](https://github.com/defenseunicorns/zarf) to package my configurations and deploy them

## 🚀 Exploration missions

The following list contains ideas I hope to explore within this project:

- [ x ] leveraging [Cloudflare Zero Trust](https://willswire.com/cosmology-mtls) for secure access to Big Bang apps and services
- [ ] switching out Iron Bank images for [Chainguard](https://www.chainguard.dev) where possible
- [ ] developing and deploying my own custom packages via the Wrapper as described [here](https://docs-bigbang.dso.mil/latest/docs/guides/deployment-scenarios/extra-package-deployment/)
