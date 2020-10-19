workspace(name = "test_crow")

# add deps for boost
load("@//third_party:deps.bzl", "cc_deps")

cc_deps()


load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Gtest
http_archive(
    name = "gtest",
    url = "https://github.com/google/googletest/archive/release-1.7.0.zip",
    sha256 = "b58cb7547a28b2c718d1e38aee18a3659c9e3ff52440297e965f5edffe34b6d0",
    strip_prefix = "googletest-release-1.7.0",
    build_file="@//third_party:gtest.BUILD"
)

# Download the rules_docker repository at release v0.14.4
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "480daa8737bf4370c1a05bfced903827e75046fea3123bd8c81389923d968f55",
    strip_prefix = "rules_docker-0.11.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.11.0/rules_docker-v0.11.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//toolchains/docker:toolchain.bzl",
    docker_toolchain_configure="toolchain_configure"
)

docker_toolchain_configure(
    name = "docker_config",
    docker_path = "/usr/bin/docker",
)

load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repositories = "repositories",)
container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")
container_deps()

load("@io_bazel_rules_docker//repositories:pip_repositories.bzl", "pip_deps")
pip_deps()

load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)

load(
    "@io_bazel_rules_docker//cc:image.bzl",
    _cc_image_repos = "repositories",
)

# load CXX optimized docker images
_cc_image_repos()

container_pull(
    name = "cxx_container",
    registry = "index.docker.io",
    repository = "library/ubuntu",
    tag = "focal",
)

# docker image used by client
load("@io_bazel_rules_docker//container:container.bzl", "container_pull")

container_pull(
    name = "centos7_with_curl",
    registry = "ghcr.io",
    repository = "kubecorn/test-crow/centos7_curl",
    tag = "1.0",
)
