#!/bin/bash

# TODO: make these variables command arguments
APP_VERSION="0.1"
APP_NAME="tw-jupyter"

CONTAINER_ID=$(docker ps -a --filter "ancestor=${APP_NAME}:${APP_VERSION}" --format "{{.ID}}")

# Remove the container
if [ -n "$CONTAINER_ID" ]; then
    echo "Stopping container $CONTAINER_ID..."
    docker stop "$CONTAINER_ID"
    echo "Removing container $CONTAINER_ID..."
    docker rm "$CONTAINER_ID"
fi

# Remove the image
IMAGE_ID=$(docker images --format '{{.Repository}}:{{.Tag}}' | grep ${APP_NAME}:${APP_VERSION})

if [ -n "$IMAGE_ID" ]; then
    echo "Removing image $IMAGE_ID..."
    docker rmi "$IMAGE_ID"
fi

echo "Cleanup complete."
