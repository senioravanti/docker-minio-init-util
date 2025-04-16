FROM bitnami/minio:2025

USER root
RUN mkdir -p /usr/local/share/vault/secrets
VOLUME [ "/usr/local/share/vault/secrets" ]

RUN apt-get update \
    && apt-get install -y \
        curl \
        jq \
        pwgen

COPY ./scripts/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh
USER 1001

CMD [ "/usr/local/bin/docker-entrypoint.sh" ]