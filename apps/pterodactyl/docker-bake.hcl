target "docker-metadata-action" {}

variable "APP" {
  default = "pterodactyl-panel"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=pterodactyl/panel
  default = "v1.11.11"
}

variable "SOURCE" {
  default = "https://github.com/pterodactyl/panel"
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
    "linux/amd64",
    "linux/arm64"
  ]
}
