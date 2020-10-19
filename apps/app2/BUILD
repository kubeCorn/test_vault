cc_binary(
    name = "app2_bin",
    srcs = ["src/server.cpp"],
    deps = ["//third_party/Config:libconfig","//third_party/crow:libcrow","//third_party/getTimeOfDay:libtime"],
    linkopts = ["-lpthread"],
    visibility = ["//visibility:public"],
)

load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_push")
load("//:var.bzl", "APP2_PORT", "SERVER_MESSAGE")

container_image(
    name = "app2_image",
    base = "@cxx_container//image",
    files = [":app2_bin"],
    entrypoint = ["./app2_bin"],
    ports = ["9080"],
    stamp = True,
    repository = "crow",
    labels = {
        "com.crow.app2": "v1"
    },
    env = {
        "APP2_PORT": APP2_PORT,
        "SERVER_MESSAGE": SERVER_MESSAGE,
    },
)


container_push(
   name = "app2_push",
   image = ":app2_image",
   format = "Docker",
   registry = "ghcr.io",
   repository = "kubecorn/test_vault/app2",
   #tag = "v1",
  tag = "{BUILD_EMBED_LABEL}"

)

