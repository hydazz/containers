target "docker-metadata-action" {}

variable "APP" {
  default = "munkireport"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=munkireport/munkireport-php
  default = "v5.8.0"
}

variable "SOURCE" {
  default = "https://github.com/munkireport/munkireport-php"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
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
