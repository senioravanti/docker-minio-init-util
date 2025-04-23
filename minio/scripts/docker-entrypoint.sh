curl -sS -i \
    -o /tmp/minio-root-password-response.txt \
    -H "Authorization: Bearer $(cat /usr/local/share/vault/secrets/root-token.txt)" \
    http://vault:8200/v1/cubbyhole/minio/root-password

if [ $(head -n 1 /tmp/minio-root-password-response.txt | awk '{print $2}') -eq 404 ]; then
    export MINIO_ROOT_PASSWORD=$(pwgen -1cns 24)
    printf "uploading root password to the vault\n"
    curl -sS -i \
        -H "Authorization: Bearer $(cat /usr/local/share/vault/secrets/root-token.txt)" \
        -X POST \
        --json "{\"data\":{\"value\":\"$MINIO_ROOT_PASSWORD\"}}" \
        http://vault:8200/v1/cubbyhole/minio/root-password
    printf "curl exit code: $?\n"
else
    printf "fetch password from the vault\n"
    export MINIO_ROOT_PASSWORD=$(tail -n 1 /tmp/minio-root-password-response.txt \
        | jq -r .data.data.value)
fi

minio server /bitnami/minio/data \
    --console-address '0.0.0.0:9001' \
    --address '0.0.0.0:9000' \