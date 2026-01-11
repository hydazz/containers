target "docker-metadata-action" {}

variable "APP" {
  default = "wordpress"
}

variable "VERSION" {
  // renovate: datasource=docker depName=wordpress versioning=docker
  default = "6.9.0-php8.4"
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
