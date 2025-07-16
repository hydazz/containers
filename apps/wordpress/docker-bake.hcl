target "docker-metadata-action" {}

variable "APP" {
  default = "wordpress"
}

variable "VERSION" {
  // renovate: datasource=docker depName=wordpress versioning=docker
  default = "6.8.2-fpm-alpine"
}

variable "TAG" {
  // renovate: datasource=docker depName=wordpress versioning=docker
  default = "6.8.1-fpm-alpine@sha256:82eac77ce336f1b74fbdd346d67080b2ffb0e6f1840955d61824a491ec779a3c"
}

variable "SOURCE" {
  default = "https://github.com/docker-library/wordpress"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    TAG = "${TAG}"
  }
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
  tags = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64"
  ]
}
