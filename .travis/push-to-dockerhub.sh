#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

version=`cat VERSION`
id=`docker image inspect projectriff/builder --format '{{.Id}}' | awk '{print substr($1, 8, 12)}'`
CI_TAG="${version}-ci-${id}"

docker tag projectriff/builder:latest projectriff/builder:${version}
docker tag projectriff/builder:latest projectriff/builder:${CI_TAG}

docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"
docker push projectriff/builder:${version}
docker push projectriff/builder:${CI_TAG}
