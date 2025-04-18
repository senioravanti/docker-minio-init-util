set -u

ROOT_TOKEN=$(cat /usr/local/share/vault/secrets/root-token.txt)
export MINIO_ROOT_PASSWORD=$(curl -sS \
    -H "Authorization: Bearer $ROOT_TOKEN" \
    http://vault:8200/v1/cubbyhole/minio/root-password | jq -r .data.data.value)

curl -sS \
    -X LIST \
    -H "Authorization: Bearer $ROOT_TOKEN" \
    http://vault:8200/v1/cubbyhole/minio/ \
    | jq -r '.data.keys' \
    | grep -Fq 'keys'

if [ $? -ne 0 ]; then
    mc alias set local "http://$MINIO_HOSTNAME:$MINIO_SERVER_PORT" $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD

    printf "generating client keys ...\n"
    mkdir -p /tmp/minio/client
    mc admin accesskey create local/ $MINIO_ROOT_USER | head -n 2 > /tmp/minio/client/credentials.txt
    echo $?

    cat /tmp/minio/client/credentials.txt | head -n 1 | awk '{print $3}' > /tmp/minio/client/accesskey.txt
    cat /tmp/minio/client/credentials.txt | tail -n 1 | awk '{print $3}' > /tmp/minio/client/secretkey.txt

    if [ -s /tmp/minio/client/accesskey.txt -a -s /tmp/minio/client/secretkey.txt ]; then
        printf "uploading keys to the vault ...\n"
        curl -sS -i \
            -H "Authorization: Bearer $(cat /usr/local/share/vault/secrets/root-token.txt)" \
            -X POST \
            --json "{\"data\":{\"value\":\"$(cat /tmp/minio/client/accesskey.txt)\"}}" \
            http://vault:8200/v1/cubbyhole/minio/keys/access-key
        echo $?

        curl -sS -i \
            -H "Authorization: Bearer $(cat /usr/local/share/vault/secrets/root-token.txt)" \
            -X POST \
            --json "{\"data\":{\"value\":\"$(cat /tmp/minio/client/secretkey.txt)\"}}" \
            http://vault:8200/v1/cubbyhole/minio/keys/secret-key
        echo $?
    else
        printf "error: keys is empty ...\n"
        exit 1
    fi
fi

printf "execute cmd ..."
exec /bin/sh "$@"