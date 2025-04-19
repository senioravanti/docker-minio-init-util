# Образ для minio, адаптированный для работы с HasiCorp Vault

Утилита сохранит root token в файл `./vault/secrets/root-token.txt`

[Руководство по использованию расширения образа minio](./minio/README.md)
[Руководство по использованию образа init-minio](./init-minio/README.md)

```sh
docker compose up -d
```