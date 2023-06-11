#!/bin/sh

#CONTAINER=docker
CONTAINER=podman
PLATFORM=linux/arm64/v8

# sudo $CONTAINER run --rm --privileged multiarch/qemu-user-static --reset -p yes
$CONTAINER buildx build --platform $PLATFORM --no-cache --build-arg GIT_REPO=$GIT_REPO .
$CONTAINER image prune --filter label=stage=builder

echo "$CONTAINER save -o image.tar [image hash|image name] # save docker image as tar file"
echo "$CONTAINER load -i image.tar # load from target machine"

