#!/bin/sh

# sources:
# https://www.ory.sh/docs/hydra/self-hosted/configure-deploy#perform-oauth-20-flow
# https://www.ory.sh/docs/hydra/5min-tutorial

CLIENT_NAME=facebook-photo-backup
CLIENT_SECRET=some-secret

CLIENT_ID=$(docker compose exec hydra \
  hydra list clients \
    --endpoint http://127.0.0.1:4445 \
    --format json | jq -r ".items[] | select(.client_name == \"$CLIENT_NAME\") | .client_id")

# docker compose exec hydra \
#   hydra delete client $CLIENT_ID \
#     --endpoint http://127.0.0.1:4445 \
#     --quiet
# CLIENT_ID=
# exit 0

if [ -z "$CLIENT_ID" ]; then
  echo "Client $CLIENT_NAME not found, creating it"

  CLIENT_ID=$(docker compose exec hydra \
    hydra create client \
      --endpoint http://127.0.0.1:4445 \
      --format json \
      --grant-type authorization_code \
      --grant-type client_credentials \
      --grant-type implicit \
      --grant-type refresh_token \
      --name $CLIENT_NAME \
      --redirect-uri http://127.0.0.1:5555/callback \
      --response-type code \
      --response-type id_token \
      --response-type token \
      --scope openid,offline,photos.read \
      --secret $CLIENT_SECRET | jq -r ".client_id")
fi

docker compose exec hydra \
  hydra perform authorization-code \
    --client-id $CLIENT_ID \
    --client-secret $CLIENT_SECRET \
    --endpoint http://127.0.0.1:4444/ \
    --port 5555 \
    --scope offline \
    --scope openid
