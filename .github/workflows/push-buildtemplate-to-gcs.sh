#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly version=$(cat VERSION)
readonly git_branch=${1:11} # drop 'refs/head/' prefix
readonly git_sha=$(git rev-parse HEAD)
readonly git_timestamp=$(TZ=UTC git show --quiet --date='format-local:%Y%m%d%H%M%S' --format="%cd")
readonly slug=${version}-${git_timestamp}-${git_sha:0:16}

echo "Publish function builder"

sed "s|projectriff/builder:latest|projectriff/builder:${slug}|" riff-function-clusterbuilder.yaml > riff-function-clusterbuilder-${slug}.yaml
sed "s|projectriff/builder:latest|projectriff/builder:${version}|" riff-function-clusterbuilder.yaml > riff-function-clusterbuilder-${version}.yaml

gsutil cp riff-function-clusterbuilder-${slug}.yaml gs://projectriff/riff-buildtemplate/
gsutil cp riff-function-clusterbuilder-${version}.yaml gs://projectriff/riff-buildtemplate/
gsutil cp riff-function-clusterbuilder-${slug}.yaml gs://projectriff/riff-buildtemplate/riff-function-clusterbuilder.yaml

echo "Publish application builder"

gsutil cp riff-application-clusterbuilder.yaml gs://projectriff/riff-buildtemplate/riff-application-clusterbuilder-${slug}.yaml
gsutil cp riff-application-clusterbuilder.yaml gs://projectriff/riff-buildtemplate/riff-application-clusterbuilder-${version}.yaml
gsutil cp riff-application-clusterbuilder.yaml gs://projectriff/riff-buildtemplate/riff-application-clusterbuilder.yaml

# update version references
echo "Publish builder references"

gsutil -h 'Content-Type: text/plain' -h 'Cache-Control: private' cp <(echo "${slug}") gs://projectriff/riff-buildtemplate/versions/builds/${git_branch}
gsutil -h 'Content-Type: text/plain' -h 'Cache-Control: private' cp <(echo "${slug}") gs://projectriff/riff-buildtemplate/versions/builds/${version}
if [[ ${version} != *"-snapshot" ]] ; then
  gsutil -h 'Content-Type: text/plain' -h 'Cache-Control: private' cp <(echo "${slug}") gs://projectriff/riff-buildtemplate/versions/releases/${git_branch}
  # avoids overwriting existing values
  gsutil -h 'Content-Type: text/plain' -h 'Cache-Control: private' cp -n <(echo "${slug}") gs://projectriff/riff-buildtemplate/versions/releases/${version}
fi
