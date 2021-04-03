resource "google_artifact_registry_repository" "cantodarua-repo" {
  provider = google-beta

  location      = var.region
  repository_id = "cantodarua-repo"
  description   = "repository for cantodarua"
  format        = "DOCKER"
}

output "registry_repository_name" {
  value = google_artifact_registry_repository.cantodarua-repo.name
}