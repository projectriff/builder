buildpacks = [
  { id = "io.projectriff.command",       uri = "https://storage.googleapis.com/projectriff/command-function-buildpack/io.projectriff.command-$(curl -s https://storage.googleapis.com/projectriff/command-function-buildpack/versions/snapshots/master).tgz" },
  { id = "io.projectriff.java",          uri = "https://storage.googleapis.com/projectriff/java-function-buildpack/io.projectriff.java-$(curl -s https://storage.googleapis.com/projectriff/java-function-buildpack/versions/snapshots/master).tgz" },
  { id = "io.projectriff.node",          uri = "https://storage.googleapis.com/projectriff/node-function-buildpack/io.projectriff.node-$(curl -s https://storage.googleapis.com/projectriff/node-function-buildpack/versions/snapshots/master).tgz" },

  { id = "org.cloudfoundry.buildsystem", uri = "https://storage.googleapis.com/cnb-buildpacks/build-system-cnb/org.cloudfoundry.buildsystem-1.0.107.tgz" },
  { id = "org.cloudfoundry.node-engine", uri = "https://github.com/cloudfoundry/node-engine-cnb/releases/download/v0.0.82/node-engine-cnb-0.0.82.tgz" },
  { id = "org.cloudfoundry.npm",         uri = "https://github.com/cloudfoundry/npm-cnb/releases/download/v0.0.50/npm-cnb-0.0.50.tgz" },
  { id = "org.cloudfoundry.openjdk",     uri = "https://storage.googleapis.com/cnb-buildpacks/openjdk-cnb/org.cloudfoundry.openjdk-1.0.46.tgz" },
]

[[order]]
group = [
  { id = "org.cloudfoundry.openjdk" },
  { id = "org.cloudfoundry.buildsystem", optional = true },
  { id = "io.projectriff.java" },
]

[[order]]
group = [
  { id = "org.cloudfoundry.node-engine" },
  { id = "org.cloudfoundry.npm" },
  { id = "io.projectriff.node" },
]

[[order]]
group = [
  { id = "org.cloudfoundry.node-engine" },
  { id = "io.projectriff.node" },
]

[[order]]
group = [
 { id = "io.projectriff.command" },
]

[stack]
id          = "io.buildpacks.stacks.bionic"
build-image = "cloudfoundry/build:base-cnb"
run-image   = "cloudfoundry/run:base-cnb"
