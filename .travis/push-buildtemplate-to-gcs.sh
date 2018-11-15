#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

version=`cat VERSION`
gcloud auth activate-service-account --key-file <(echo $GCLOUD_CLIENT_SECRET | base64 --decode)

sed "s|projectriff/builder:latest|projectriff/builder:${CI_TAG}|" riff-cnb-buildtemplate.yaml > riff-cnb-buildtemplate-${CI_TAG}.yaml

gsutil cp -a public-read riff-cnb-buildtemplate-${CI_TAG}.yaml gs://projectriff/riff-buildtemplate/
gsutil cp -a public-read riff-cnb-buildtemplate.yaml gs://projectriff/riff-buildtemplate/

