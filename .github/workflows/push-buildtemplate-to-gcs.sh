#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly git_tag=${1:11} # drop 'refs/tags/v' prefix

echo "Publish function builder"

sed "s|projectriff/builder:latest|projectriff/builder:${git_tag}|" riff-function-clusterbuilder.yaml > riff-function-clusterbuilder-${git_tag}.yaml

gsutil cp riff-function-clusterbuilder-${git_tag}.yaml gs://projectriff/riff-buildtemplate/riff-function-clusterbuilder-${git_tag}.yaml
gsutil cp riff-function-clusterbuilder-${git_tag}.yaml gs://projectriff/riff-buildtemplate/riff-function-clusterbuilder.yaml

echo "Publish application builder"

gsutil cp riff-application-clusterbuilder.yaml gs://projectriff/riff-buildtemplate/riff-application-clusterbuilder-${git_tag}.yaml
gsutil cp riff-application-clusterbuilder.yaml gs://projectriff/riff-buildtemplate/riff-application-clusterbuilder.yaml
