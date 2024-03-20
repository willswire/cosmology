# Running keycloak in a container

```console
docker run \
    --rm \
    -v /Users/willwalker/Developer/cosmology/keycloak:/kc \
    -p 8443:8443 \
    -e KEYCLOAK_ADMIN=admin \
    -e KEYCLOAK_ADMIN_PASSWORD=admin \
    quay.io/keycloak/keycloak:24.0.1 \
    start-dev \
    --https-certificate-file=/kc/certificate.pem \
    --https-certificate-key-file=/kc/key.pem \
    --https-client-auth=request \
    --truststore-paths=/kc/dod_ca.pem,/kc/dod_pke_chain.pem
```

Working with KC and CF, I'm realizing that CF will always attempt to send an mTLS cert when connecting. Can my KC be behind CF and still allow me to do client-based auth?