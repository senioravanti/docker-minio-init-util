FROM alpine:3.21

RUN mkdir /docker-entrypoint-init.d \
    && mkdir -p /usr/local/share/vault/secrets \
    && mkdir -p /usr/local/share/minio
VOLUME [ "/docker-entrypoint-init.d", "/usr/local/share/vault/secrets", "/usr/local/share/minio" ]

RUN apk add --no-cache --update \
    curl \
    jq \
    pwgen

RUN curl -o /usr/local/bin/mc \
    https://dl.min.io/client/mc/release/linux-amd64/mc \
    && chmod +x /usr/local/bin/mc

COPY ./scripts/* /usr/local/bin/init-minio/
RUN chmod +x /usr/local/bin/init-minio/*.sh

ENV MINIO_HOSTNAME=minio
ENV MINIO_SERVER_PORT=9000

ENV MINIO_ROOT_USER=minioadmin

ENTRYPOINT [ "/bin/sh", "/usr/local/bin/init-minio/docker-entrypoint.sh" ]