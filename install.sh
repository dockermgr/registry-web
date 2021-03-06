#!/usr/bin/env bash

APPNAME="registry-web"
DOCKER_HUB_URL="konradkleine/docker-registry-frontend:v2"

sudo mkdir -p "$DATADIR"
sudo chmod -Rf 777 "$DATADIR"

if docker ps -a | grep "$APPNAME" >/dev/null 2>&1; then
  sudo docker rm -f "$APPNAME"
  sudo docker pull "$DOCKER_HUB_URL"
  sudo docker restart "$APPNAME"
else
  sudo docker run --name "$APPNAME" \
    -d --restart=always \
    -e ENV_DOCKER_REGISTRY_HOST=localhost \
    -e ENV_DOCKER_REGISTRY_PORT=5000 \
    -e ENV_REGISTRY_PROXY_FQDN=localhost \
    -e ENV_REGISTRY_PROXY_PORT=443 \
    -e ENV_DEFAULT_REPOSITORIES_PER_PAGE=50 \
    -e ENV_MODE_BROWSE_ONLY=false \
    -e ENV_DEFAULT_TAGS_PER_PAGE=20 \
    -e ENV_DOCKER_REGISTRY_USE_SSL=1 \
    -e ENV_USE_SSL=1 \
    -v "$DATADIR":/var/lib/registry \
    -v /etc/ssl/CA/CasjaysDev/certs/localhost.crt:/etc/apache2/server.crt:ro \
    -v /etc/ssl/CA/CasjaysDev/private/localhost.key:/etc/apache2/server.key:ro \
    -p 7080:80 \
    -p 7081:443 \
    "$DOCKER_HUB_URL"
fi
