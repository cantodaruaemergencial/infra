resource "google_artifact_registry_repository" "repo" {
  provider = google-beta

  location      = var.region
  repository_id = "${var.project}-repo"
  description   = "repository for ${var.project}"
  format        = "DOCKER"
}

output "registry_repository_name" {
  value = google_artifact_registry_repository.repo.name
}