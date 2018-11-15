#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

version=`cat VERSION`
gcloud auth activate-service-account --key-file <(echo $GCLOUD_CLIENT_SECRET | base64 --decode)

docker push projectriff/builder:${version}-ci-${TRAVIS_BUILD_NUMBER}
sed "s|projectriff/builder:latest|projectriff/builder:${version}-ci-${TRAVIS_BUILD_NUMBER}|" riff-cnb-buildtemplate.yaml > riff-cnb-buildtemplate-${version}-ci-${TRAVIS_BUILD_NUMBER}.yaml

gsutil cp -a public-read riff-cnb-buildtemplate-${version}-ci-${TRAVIS_BUILD_NUMBER}.yaml gs://projectriff/riff-buildtemplate/
gsutil cp -a public-read riff-cnb-buildtemplate.yaml gs://projectriff/riff-buildtemplate/

