# Grav Docker
Dockerfile to create a lightweight environment to host Grav site

## Setup

### Environment
- Alpine Linux (3.18.0 by default)
- Nginx
- PHP 8.2 fpm
- Grav latest

### Arguments
- ALPINE_VERSION=3.18.0
- GIT_REPO

## Instruction
You need to supply GIT_REPO agrument that points to git repository contains the contents of user directory.

### for same architecture as host

```shell
docker build --no-cache --build-arg GIT_REPO=[your grav user git repo] .
```

### cross platform build example for Arm64v8

```shell
docker buildx build --no-cache --platform linux/arm64/v8 --build-arg GIT_REPO=[your grav user git repo] .
```

