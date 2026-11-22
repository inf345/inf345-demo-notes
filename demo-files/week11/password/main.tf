# The Docker daemon on this machine. WHERE it is (a Unix socket, a Windows
# named pipe, DOCKER_HOST) is a fact about the machine, so it is not written here.
provider "docker" {}

resource "docker_image" "notes" {
  name         = var.image
  platform     = "linux/amd64" # what CI builds (Week 6); Apple-silicon Macs emulate it
  keep_locally = true          # destroy removes the container, not the downloaded image
}

resource "docker_network" "notes" {
  name = "inf345-net"
}

resource "docker_container" "notes" {
  name    = "inf345-notes"
  image   = docker_image.notes.image_id # a reference: the image must exist first
  restart = var.restart_policy
  env     = ["PORT=${var.internal_port}", "DB_PASSWORD=${var.db_password}"]

  # The same platform as the image. Without it, Docker on an Apple-silicon Mac may look
  # for an arm64 copy that was never pulled ("content digest ... not found").
  platform = "linux/amd64"

  lifecycle {
    # Docker reports the platform back as just "linux": without this, every plan
    # would want to replace the container.
    ignore_changes = [platform]
  }

  ports {
    internal = var.internal_port
    external = var.host_port
  }

  networks_advanced {
    name = docker_network.notes.name # another reference: the network first
  }
}
