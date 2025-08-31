target "docker-metadata-action" {}

variable "APP" {
  default = "unifi-protect-backup"
}

variable "VERSION" {
  // renovate: datasource=pypi depName=unifi-protect-backup
  default = "0.14.0"
}

variable "SOURCE" {
  default = "https://github.com/ep1cman/unifi-protect-backup"
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