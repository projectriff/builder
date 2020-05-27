buildpacks = [
  { id = "io.projectriff.command", uri = "https://storage.googleapis.com/projectriff/command-function-buildpack/io.projectriff.command-{{ curl -s https://storage.googleapis.com/projectriff/command-function-buildpack/versions/snapshots/master }}.tgz" },
  { id = "io.projectriff.java", uri = "https://storage.googleapis.com/projectriff/java-function-buildpack/io.projectriff.java-{{ curl -s https://storage.googleapis.com/projectriff/java-function-buildpack/versions/snapshots/master }}.tgz" },
  { id = "io.projectriff.node", uri = "https://storage.googleapis.com/projectriff/node-function-buildpack/io.projectriff.node-{{ curl -s https://storage.googleapis.com/projectriff/node-function-buildpack/versions/snapshots/master }}.tgz" },

  { id = "org.cloudfoundry.buildsystem", uri = "https://storage.googleapis.com/cnb-buildpacks/build-system-cnb/org.cloudfoundry.buildsystem-{{tpl_escape go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/build-system-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "paketo-buildpacks/node-engine", uri = "https://github.com/paketo-buildpacks/node-engine/releases/download/{{tpl_escape go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/node-engine").Version' }}/node-engine-{{tpl_escape go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/node-engine").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "paketo-buildpacks/yarn-install", uri = "https://github.com/paketo-buildpacks/yarn-install/releases/download/{{tpl_escape go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/yarn-install").Version' }}/yarn-install-{{tpl_escape go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/yarn-install").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "paketo-buildpacks/npm", uri = "https://github.com/paketo-buildpacks/npm/releases/download/{{tpl_escape go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/npm").Version' }}/npm-{{tpl_escape go mod download -json | jq -r 'select(.Path == "github.com/paketo-buildpacks/npm").Version' | sed -e 's/^v//g' }}.tgz" },
  { id = "org.cloudfoundry.openjdk", uri = "https://storage.googleapis.com/cnb-buildpacks/openjdk-cnb/org.cloudfoundry.openjdk-{{tpl_escape go mod download -json | jq -r 'select(.Path == "github.com/cloudfoundry/openjdk-cnb").Version' | sed -e 's/^v//g' }}.tgz" },
]

[[order]]
group = [
  { id = "org.cloudfoundry.openjdk" },
  { id = "org.cloudfoundry.buildsystem", optional = true },
  { id = "io.projectriff.java" },
]

[[order]]
group = [
  { id = "paketo-buildpacks/node-engine" },
  { id = "paketo-buildpacks/yarn-install" },
  { id = "io.projectriff.node" },
]

[[order]]
group = [
  { id = "paketo-buildpacks/node-engine" },
  { id = "paketo-buildpacks/npm" },
  { id = "io.projectriff.node" },
]

[[order]]
group = [
  { id = "paketo-buildpacks/node-engine" },
  { id = "io.projectriff.node" },
]

[[order]]
group = [
  { id = "io.projectriff.command" },
]

[lifecycle]
version = "0.7.2"

[stack]
id          = "io.buildpacks.stacks.bionic"
build-image = "cloudfoundry/build:base-cnb"
run-image   = "cloudfoundry/run:base-cnb"
