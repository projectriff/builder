#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

version=`cat VERSION`
branch="${TRAVIS_BRANCH}"
id=`docker image inspect projectriff/builder --format '{{.Id}}' | awk '{print substr($1, 8, 12)}'`
CI_TAG="${version}-ci-${id}"

gcloud auth activate-service-account --key-file <(echo $GCLOUD_CLIENT_SECRET | base64 --decode)

# function build template
echo "Publish function builder"

sed "s|projectriff/builder:latest|projectriff/builder:${CI_TAG}|" riff-function-clusterbuildtemplate.yaml > riff-function-clusterbuildtemplate-${CI_TAG}.yaml
sed "s|projectriff/builder:latest|projectriff/builder:${version}|" riff-function-clusterbuildtemplate.yaml > riff-function-clusterbuildtemplate-${version}.yaml

gsutil cp -a public-read riff-function-clusterbuildtemplate-${CI_TAG}.yaml gs://projectriff/riff-buildtemplate/
gsutil cp -a public-read riff-function-clusterbuildtemplate-${version}.yaml gs://projectriff/riff-buildtemplate/
gsutil cp -a public-read riff-function-clusterbuildtemplate-${CI_TAG}.yaml gs://projectriff/riff-buildtemplate/riff-function-clusterbuildtemplate.yaml

# application build template
echo "Publish application builder"

gsutil cp -a public-read riff-application-clusterbuildtemplate.yaml gs://projectriff/riff-buildtemplate/riff-application-clusterbuildtemplate-${CI_TAG}.yaml
gsutil cp -a public-read riff-application-clusterbuildtemplate.yaml gs://projectriff/riff-buildtemplate/riff-application-clusterbuildtemplate-${version}.yaml
gsutil cp -a public-read riff-application-clusterbuildtemplate.yaml gs://projectriff/riff-buildtemplate/riff-application-clusterbuildtemplate.yaml

# update version references
echo "Publish builder references"

echo "${CI_TAG}" | gsutil -h 'Content-Type: text/plain' -h 'Cache-Control: private' cp -a public-read -I gs://projectriff/riff-buildtemplate/versions/builds/${branch}
echo "${CI_TAG}" | gsutil -h 'Content-Type: text/plain' -h 'Cache-Control: private' cp -a public-read -I gs://projectriff/riff-buildtemplate/versions/builds/${version}
if [[ ${version} != *"-snapshot" ]] ; then
  echo "${CI_TAG}" | gsutil -h 'Content-Type: text/plain' -h 'Cache-Control: private' cp -a public-read -I gs://projectriff/riff-buildtemplate/versions/releases/${branch}
  # avoids overwriting existing values
  echo "${CI_TAG}" | gsutil -n -h 'Content-Type: text/plain' -h 'Cache-Control: private' cp -a public-read -I gs://projectriff/riff-buildtemplate/versions/releases/${version}
fi
