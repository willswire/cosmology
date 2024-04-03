# clip: Cloudflare-Istio publisher

Clip is a simple tool that publishes the public IP address of an Istio gateway to the Cloudflare API to update A records for a domain.

## Building

The primary clip deployment uses a container built with Chainguard's Melange and Apko tools.

```console
# Drop into the source folder
cd src

# Build the source APKs with melange (you must have the melange.rsa private key, or generate your own)
melange build melange.yaml --signing-key melange.rsa

# Create and publish the container from the APKs
apko publish apko.yaml registry.gitlab.com/willswire/cosmology/clip:1.0 -k melange.rsa.pub
```
