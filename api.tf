resource "google_cloud_run_service" "api" {
  name     = "api"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/placeholder"
        env {
          name  = "DATABASE_HOST"
          value = google_sql_database_instance.db.public_ip_address
        }
        env {
          name  = "DATABASE_NAME"
          value = google_sql_database.schema.name
        }
        env {
          name  = "DATABASE_USERNAME"
          value = google_sql_user.user.name
        }
        env {
          name  = "DATABASE_PASSWORD"
          value = random_id.password.hex
        }
        env {
          name = "GOOGLE_CLIENT_ID"
          value = var.google_client_id
        }
        env {
          name = "GOOGLE_CLIENT_SECRET"
          value = var.google_client_secret
        }
      }
    }
  }
  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "api" {
  service  = google_cloud_run_service.api.name
  location = google_cloud_run_service.api.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "api_url" {
  value = google_cloud_run_service.api.status[0].url
}
