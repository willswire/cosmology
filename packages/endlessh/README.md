# Endlessh: an SSH tarpit

[Endlessh is an SSH tarpit](https://github.com/skeeto/endlessh) that very slowly sends an endless, random SSH banner. It keeps SSH clients locked up for hours or even days at a time. The purpose is to put your real SSH server on another port and then let the script kiddies get stuck in this tarpit instead of bothering a real server.

For the purposes of Cosmology, I've built a container for the endlessh program with Chainguard's apko and melange, and created a Helm chart.

## Build instructions

```console
# Drop into the source folder
cd src

# Build the source APKs with melange (you must have the melange.rsa private key, or generate your own)
melange build melange.yaml --signing-key melange.rsa

# Create and publish the container from the APKs
apko publish apko.yaml registry.gitlab.com/willswire/cosmology/endlessh/server:1.0 -k melange.rsa.pub
```
