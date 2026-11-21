variable "image" {
  description = "The image to run: the notes service from ghcr.io, tagged with a commit SHA (never latest)"
  type        = string
  default     = "ghcr.io/inf345/inf345-demo-notes:c5a1ecbfac5eebc6fb778c51dad30127f69f2c04"
}

variable "internal_port" {
  description = "The port the service listens on inside the container - the contract's PORT"
  type        = number
  default     = 8080
}

variable "host_port" {
  description = "The port on this laptop: http://localhost:<host_port>/healthz"
  type        = number
  default     = 8080
}

variable "restart_policy" {
  description = "What Docker does when the service exits: no, on-failure, always or unless-stopped"
  type        = string
  default     = "no"

  validation {
    condition     = contains(["no", "on-failure", "always", "unless-stopped"], var.restart_policy)
    error_message = "restart_policy must be one of: no, on-failure, always, unless-stopped."
  }
}

variable "db_password" {
  description = "DEMO 3 ONLY: a fake database password. Pass it as TF_VAR_db_password, never in a file"
  type        = string
  sensitive   = true
}
