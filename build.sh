#!/bin/sh

ORG=chihchun
PROJECT=$(basename $(readlink -f ..))
VERSION=$(basename $(readlink -f .))
DOCKER_TAG=${ORG}/${PROJECT}:${VERSION}
DOCKER_LATEST_TAG=${ORG}/${PROJECT}:latest

echo -n "Building ${DOCKER_TAG} ... continue? [y]"
read ans

docker start squid-deb-proxy
set -x
docker build \
    --build-arg http_proxy=http://$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' squid-deb-proxy):8000 \
    -t $DOCKER_TAG  . && docker tag $DOCKER_TAG ${DOCKER_LATEST_TAG}
echo $DOCKER_TAG
