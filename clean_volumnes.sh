#!/bin/bash

# TODO: make these variables command arguments
APP_VERSION="0.1"
APP_NAME="tw-jupyter"

# Remove the volume
VOLUME_NAME="${APP_NAME}-${APP_VERSION}-data"
VOLUME_ID=$(docker volume ls --filter "name=${VOLUME_NAME}" --format "{{.Name}}")

if [ -n "$VOLUME_ID" ]; then
    echo "Removing volume $VOLUME_ID..."
    docker volume rm "$VOLUME_ID"
fi

echo "Cleanup complete."
