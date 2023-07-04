# Cosmology

Working with Big Bang can be tricky. Especially when developing on a shared cluster with other team members. This project provides a playground for several of my personal "quests" in exploring novel functionality and features within Big Bang. In order to test my ideas and experiment on the cheap, I use the following technologies:

- [Terraform](https://www.terraform.io) to dynamically spin up infrastructure via [GitLab CI/CD](https://docs.gitlab.com/ee/ci/)
- Managed Kubernetes on [Symbiosis](https://symbiosis.host) (almost a quarter of the cost of EKS on AWS!)
- [Zarf](https://github.com/defenseunicorns/zarf) to package my configurations and deploy them

## Exploration efforts

The following list contains ideas I hope to explore within this project:

- [ ] leveraging [Cloudflare Zero Trust](https://www.cloudflare.com/zero-trust/) for ICAM to Big Bang apps and services
- [ ] switching out Iron Bank images for [Chainguard](https://www.chainguard.dev) where possible
- [ ] developing and deploying my own custom packages via the Wrapper as described [here](https://docs-bigbang.dso.mil/latest/docs/guides/deployment-scenarios/extra-package-deployment/)
