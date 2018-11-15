#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

version=`cat VERSION`

docker tag projectriff/builder:latest projectriff/builder:${version}
docker tag projectriff/builder:latest projectriff/builder:${version}-ci-${TRAVIS_BUILD_NUMBER}

docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"
docker push projectriff/builder