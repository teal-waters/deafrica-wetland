#!/bin/bash

# TODO: make these variables command arguments
APP_VERSION=$1
APP_NAME="tw-jupyter"

docker build -t ${APP_NAME}:${APP_VERSION} .
docker volume create ${APP_NAME}-${APP_VERSION}-data

docker run -p 8888:8888 \
    -v ${APP_NAME}-${APP_VERSION}-data:/data \
    --name ${APP_NAME}-${APP_VERSION} \
    ${APP_NAME}:${APP_VERSION}

docker image ls ${APP_NAME}

docker ps --filter "name=${APP_NAME}-${APP_VERSION}"