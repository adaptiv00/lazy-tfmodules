#!/usr/bin/env bash

REGISTRY_FOLDER="$REGISTRY_FOLDER"

if [ `docker ps | grep registry-mirror | wc -l | xargs` = 0 ]; then
  docker pull registry:2 >/dev/null
  docker stop -t=0 registry-mirror >/dev/null
  docker rm -f registry-mirror
  docker run -d --restart always --net=host --name registry-mirror \
    -v $REGISTRY_FOLDER/registry-mirror.yml:/etc/docker/registry/config.yml \
    -v $REGISTRY_FOLDER:/var/lib/registry \
    registry:2
fi