# Утилита, инициализирующая minio

## Сборка и развертывание

```sh
clear ; docker build \
    --no-cache \
    -t 'stradiavanti/init-minio:0.1' .
```

```sh
VAULT_ROOT_TOKEN_FILE=''
VAULT_NETWORK=''
MINIO_NETWORK=''

SCRIPT_DIR=''

clear ; docker run -d --name 'my-init-minio' \
    -v "$VAULT_ROOT_TOKEN_FILE:/usr/local/share/vault/secrets/root-token.txt" \
    -v "$SCRIPT_DIR:/docker-entrypoint-init.d" \
    --network "$VAULT_NETWORK" \
    --network "$MINIO_NETWORK" \
    'stradiavanti/init-minio:0.1'
```

### Удалить ключи 

```sh
clear ; curl -sS -i \
    -X DELETE \
    -H "Authorization: Bearer $ROOT_TOKEN" \
    http://localhost:8200/v1/cubbyhole/minio/keys/access-key
```

```sh
clear ; curl -sS -i \
    -X DELETE \
    -H "Authorization: Bearer $ROOT_TOKEN" \
    http://localhost:8200/v1/cubbyhole/minio/keys/secret-key
```

## Пример compose-файла

