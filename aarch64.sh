#!/bin/sh

docker buildx build --platform linux/aarch64 --no-cache --build-arg GIT_REPO=$GIT_REPO .

echo "docker save -o grav-image.tar [image hash|image name] # save docker image as tar file"
echo "docker load -i grav-image.tar # load from target machine"

