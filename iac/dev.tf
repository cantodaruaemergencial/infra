resource "google_sql_database" "schema_dev" {
  name     = "${var.project}-db-dev"
  project  = var.project
  instance = google_sql_database_instance.db.name
}

resource "random_id" "password_dev" {
  byte_length = 16
}

resource "google_sql_user" "user_dev" {
  name     = "${var.project}-user-dev"
  project  = var.project
  instance = google_sql_database_instance.db.name
  host     = "%"
  password = random_id.password_dev.hex
}

output "database_credentials_dev" {
  value = {
    user = google_sql_user.user_dev.name
    pass = random_id.password_dev.hex
  }
}

resource "google_cloud_run_service" "api_dev" {
  name     = "api-dev"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/cantodarua/api-dev:e6bc4793194d1a24c0d3e695148763e338a18e20"
        env {
          name  = "DATABASE_HOST"
          value = google_sql_database_instance.db.public_ip_address
        }
        env {
          name  = "DATABASE_NAME"
          value = google_sql_database.schema_dev.name
        }
        env {
          name  = "DATABASE_USERNAME"
          value = google_sql_user.user_dev.name
        }
        env {
          name  = "DATABASE_PASSWORD"
          value = random_id.password_dev.hex
        }
        env {
          name  = "GOOGLE_CLIENT_ID"
          value = var.google_client_id
        }
        env {
          name  = "GOOGLE_CLIENT_SECRET"
          value = var.google_client_secret
        }
      }
    }
  }
  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "api_dev" {
  service  = google_cloud_run_service.api_dev.name
  location = google_cloud_run_service.api_dev.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "api_dev_url" {
  value = google_cloud_run_service.api_dev.status[0].url
}