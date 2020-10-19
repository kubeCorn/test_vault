cc_binary(
    name = "app1_bin",
    srcs = ["include/client.hpp","src/client.cpp","include/server_client.hpp","src/server_client.cpp"],
    linkopts = ["-lcurl", "-lpthread"],
    deps = [
       "//third_party/Config:libconfig",
       "//third_party/getTimeOfDay:libtime",
       "//third_party/crow:libcrow",
       "@boost//:algorithm",
       "@boost//:asio",
       "@boost//:system",
    ],
)

load("@io_bazel_rules_docker//container:container.bzl", "container_image","container_push")
load("//:var.bzl", "APP1_PORT", "APP2_PORT", "CLIENT_DELAY_MS","CLIENT_MAX_DURATION_SECONDS", "K8S_CLIENT_TO_SERVER_ENDPOINT")

container_image(
    name = "app1_image",
    base = "@centos7_with_curl//image",
    files = [":app1_bin"],
    entrypoint = ["./app1_bin"],
    ports = ["9081"],
    stamp = True,
    repository = "crow",
    labels = {
        "com.crow.app1": "v1"
    },
    env = {
        "APP2_PORT": APP2_PORT,
        "APP1_PORT": APP1_PORT,
        "CONTAINERIZED_ENV": "true",
        "CLIENT_DELAY_MS": CLIENT_DELAY_MS,
        "CLIENT_MAX_DURATION_SECONDS": CLIENT_MAX_DURATION_SECONDS,
    },
)

container_push(
   name = "app1_push",
   image = "app1_image",
   format = "Docker",
   registry = "ghcr.io",
   repository = "kubecorn/test_vault/app1",
   tag = "{BUILD_EMBED_LABEL}"
)

## K8S

container_image(
    name = "app1_image_k8s",
    base = "@centos7_with_curl//image",
    files = [":app1_bin"],
    entrypoint = ["./app1_bin"],
    ports = ["9081"],
    stamp = True,
    repository = "crow",
    labels = {
        "com.crow.app1": "v1"
    },
    env = {
        "APP2_PORT": APP2_PORT,
        "APP1_PORT": APP1_PORT,
        "CLIENT_DELAY_MS": CLIENT_DELAY_MS,
        "CLIENT_MAX_DURATION_SECONDS": CLIENT_MAX_DURATION_SECONDS,
        "SERVER_ENDPOINT": K8S_CLIENT_TO_SERVER_ENDPOINT
    },
)

container_push(
   name = "app1_push_k8s",
   image = ":app1_image_k8s",
   format = "Docker",
   registry = "ghcr.io",
   repository = "kubecorn/test_vault/app1",
   tag = "{BUILD_EMBED_LABEL}"
)
