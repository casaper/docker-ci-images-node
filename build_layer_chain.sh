#!/usr/bin/env bash

REPO_WEB_URL='https://hub.docker.com/r/casaper/docker-ci-images-ruby-and-rails-repo'

. ./lib.sh
. ./build_layer_chain_options.sh

NODE_VERSION_TAG="${NODE_VERSION_TAG:-latest}"
BUILD_CHROME_LAYER="${BUILD_CHROME_LAYER:-skip}"
PUSH_TO_HUB="${PUSH_TO_HUB:-skip}"
PUSH_LAST_AS_LATEST="${PUSH_LAST_AS_LATEST:-skip}"
DOCKER_REPOSITORY="${CUSTOM_REPO:-casaper/docker-ci-images-node}"

# build base image
BASE_IMAGE_TAG="${DOCKER_REPOSITORY}:${NODE_VERSION_TAG}"

echo "Building base image with tag ${BASE_IMAGE_TAG}"
IMAGE_STACK_STRING="node:${NODE_VERSION_TAG}"$'\n'"Tag: ${BASE_IMAGE_TAG}"$'\n\n'

docker_build_with_args -t "$BASE_IMAGE_TAG" -f Dockerfile "docker_version_tag=${NODE_VERSION_TAG}"
if [ "$PUSH_TO_HUB" == "1" ]; then push_to_docker_hub "$BASE_IMAGE_TAG"; fi

if [ "$BUILD_CHROME_LAYER" != 'skip' ]; then
  BASED_ON_TAG="$BASE_IMAGE_TAG"
  BASE_IMAGE_TAG="${BASE_IMAGE_TAG}-chrome"
  echo "Building chrome layer with docker image tag ${BASE_IMAGE_TAG}"
  IMAGE_STACK_STRING="${IMAGE_STACK_STRING}Google Chrome stable"$'\n'"Tag: ${BASE_IMAGE_TAG}"$'\n\n'
  docker build -t "$BASE_IMAGE_TAG" --build-arg "base_image=${BASED_ON_TAG}" -f chrome.Dockerfile .
  if [ "$PUSH_TO_HUB" == "1" ]; then push_to_docker_hub "$BASE_IMAGE_TAG"; fi
fi

if [ "$EXTRA_DEBS" != 'skip' ]; then
  BASED_ON_TAG="$BASE_IMAGE_TAG"
  if [ "$NO_EXTRA_DEBS_IN_TAG" == 'no-tag' ]; then
    BASE_IMAGE_TAG="${BASE_IMAGE_TAG}-extra"
  else
    for DEB_NAME in $EXTRA_DEBS; do
      BASE_IMAGE_TAG="${BASE_IMAGE_TAG}-${DEB_NAME}"
    done
  fi
  echo "Building extra packages layer with docker image tag ${BASE_IMAGE_TAG}"
  echo "With the packages: ${EXTRA_DEBS}"
  IMAGE_STACK_STRING="${IMAGE_STACK_STRING}Extra packages: ${EXTRA_DEBS}"$'\n'"Tag: ${BASE_IMAGE_TAG}"$'\n\n'
  docker build -t "$BASE_IMAGE_TAG" --build-arg "base_image=${BASED_ON_TAG}" --build-arg "extra_debs=${EXTRA_DEBS}" -f extra_debs.Dockerfile .
  if [ "$PUSH_TO_HUB" == "1" ]; then push_to_docker_hub "$BASE_IMAGE_TAG"; fi
fi

if [ "$PUSH_LAST_AS_LATEST" == '1' ]; then
  echo "pushing as latest"
  docker tag "$BASE_IMAGE_TAG" "${DOCKER_REPOSITORY}:latest"
  docker push "${DOCKER_REPOSITORY}:latest"
fi

echo "Built the following Images:"
echo $'\n --- \n\n'
echo "$IMAGE_STACK_STRING"

exit 0
