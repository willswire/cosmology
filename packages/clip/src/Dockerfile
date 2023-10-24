FROM bitnami/kubectl:1.26.6 as kubectl

FROM alpine

RUN apk add --no-cache bash curl jq

COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/

COPY script.sh script.sh

RUN chmod +x script.sh

ENV ZONE_ID ""

ENV AUTH_KEY ""

CMD [ "./script.sh" ]