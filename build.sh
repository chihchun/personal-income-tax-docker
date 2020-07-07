#!/bin/sh

ORG=chihchun
PROJECT=$(basename $(readlink -f .) -docker)
VERSION=$(date +"%Y%m%d%H%M%S")
DOCKER_TAG=${ORG}/${PROJECT}:${VERSION}
DOCKER_LATEST_TAG=${ORG}/${PROJECT}:latest

echo -n "Building ${DOCKER_TAG} ... continue? [y]"
read ans

set -x
docker build \
    -t $DOCKER_TAG  . \
    && docker tag $DOCKER_TAG ${DOCKER_LATEST_TAG}
echo $DOCKER_TAG
