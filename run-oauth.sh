#!/bin/sh

docker run --rm -it \
  -e HYDRA_ADMIN_URL=https://host.docker.internal:9001 \
  oryd/hydra:v1.9.2 \
  clients delete facebook-photo-backup \
    --skip-tls-verify 2> /dev/null

docker run --rm -it \
  -e HYDRA_ADMIN_URL=https://host.docker.internal:9001 \
  --network playground-hydra-kratos_default \
  oryd/hydra:v1.9.2 \
  clients create \
    --id facebook-photo-backup \
    --skip-tls-verify \
    --secret some-secret \
    --grant-types authorization_code,refresh_token,client_credentials,implicit \
    --response-types token,code,id_token \
    --scope openid,offline,photos.read \
    --callbacks http://127.0.0.1:9010/callback

docker run --rm -it \
  -p 9010:9010 \
  oryd/hydra:v1.9.2 \
  token user --skip-tls-verify \
    --port 9010 \
    --auth-url https://localhost:9000/oauth2/auth \
    --token-url https://host.docker.internal:9000/oauth2/token \
    --client-id facebook-photo-backup \
    --client-secret some-secret \
    --scope openid,offline,photos.read
