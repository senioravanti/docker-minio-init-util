# Дистрибутив образа minio от bitnami

## Сборка и развертывание

```sh
clear ; docker build \
    --no-cache \
    -t 'stradiavanti/bitnami-minio-vault:0.1' .
```

```sh
VAULT_ROOT_TOKEN_FILE=''
VAULT_NETWORK=''

clear ; docker run -d --name 'my-bitnami-minio-vault' \
    -v "$VAULT_ROOT_TOKEN_FILE:/usr/local/share/vault/secrets/root-token.txt" \
    --network "$VAULT_NETWORK" \
    --network-alias minio \
    -p '9000:9000' -p '9001:9001' \
    'stradiavanti/bitnami-minio-vault:0.1'
```