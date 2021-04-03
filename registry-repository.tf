resource "google_artifact_registry_repository" "repo" {
  provider = google-beta

  location      = var.region
  repository_id = "repo"
  format        = "DOCKER"
}

locals {
  api_artifact_repo = "${google_artifact_registry_repository.repo.location}-docker.pkg.dev/${google_artifact_registry_repository.repo.project}/${google_artifact_registry_repository.repo.name}/api"
}

output "registry_repository_name" {
  value = local.api_artifact_repo
}