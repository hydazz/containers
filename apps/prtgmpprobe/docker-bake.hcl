target "docker-metadata-action" {}

variable "APP" {
  default = "prtgmpprobe"
}

variable "VERSION" {
  // renovate: datasource=deb depName=prtgmpprobe versioning=deb
  default = "3.11.0-1"
}

variable "SOURCE" {
  default = "https://github.com/PaesslerAG/docker-multi-platform-probe"
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
