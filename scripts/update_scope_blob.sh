#!/usr/bin/env bash -e

IMAGE_VERSION=$(curl https://api.github.com/repos/weaveworks/scope/tags | jq -r .[].name | sort | tail -n1 | cut -c 2-)
IMAGE_NAME=weaveworks/scope
IMAGE="${IMAGE_NAME}:${IMAGE_VERSION}"
SCOPE_CONTAINER_PATH=/home/weave/scope

cleanup() {
  echo "Cleaning up..."
  rm -rf "${TMPDIR}"

  if [ "${CLEANUP_CONTAINER}" ]; then
    echo "Removing container..."
    docker rm "${CONTAINER_ID}"
  fi

  if [ "${CLEANUP_IMAGE}" ]; then
    echo "Removing docker image ${IMAGE}..."
    docker rmi "${IMAGE}"
  fi
}

trap cleanup EXIT

if [ $(docker images | grep "${IMAGE_NAME}" | grep " ${IMAGE_VERSION} " | wc -l) -eq 0 ]; then
  CLEANUP_IMAGE=true
fi

CONTAINER_ID=$(docker ps -a | grep " ${IMAGE} " | cut -d " " -f 1)

if [ "${CONTAINER_ID}" == "" ]; then
  echo "Creating container from ${IMAGE}..."
  CONTAINER_ID=$(docker create "${IMAGE}" | tail -n1)
  CLEANUP_CONTAINER=true
fi

TMPDIR=$(mktemp -d)

echo "Copying Scope binary from container..."
docker cp "${CONTAINER_ID}:${SCOPE_CONTAINER_PATH}" "${TMPDIR}"

echo "Adding blob for Scope ${IMAGE_VERSION}..."
bosh add blob "${TMPDIR}/scope" scope
