output "healthz_url" {
  description = "Where the service answers after apply"
  value       = "http://localhost:${var.host_port}/healthz"
}

output "container_id" {
  description = "The container Terraform created - compare it with docker ps"
  value       = docker_container.notes.id
}
