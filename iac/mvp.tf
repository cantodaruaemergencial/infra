resource "google_sql_database" "schema_mvp" {
  name     = "${var.project}-db-mvp"
  project  = var.project
  instance = google_sql_database_instance.db.name
}

resource "random_id" "password_mvp" {
  byte_length = 16
}

resource "google_sql_user" "user_mvp" {
  name     = "${var.project}-user-mvp"
  project  = var.project
  instance = google_sql_database_instance.db.name
  host     = "%"
  password = random_id.password_mvp.hex
}

output "database_credentials_mvp" {
  value = {
    user = google_sql_user.user_mvp.name
    pass = random_id.password_mvp.hex
  }
}

resource "google_cloud_run_service" "api_mvp" {
  name     = "api-mvp"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/cantodarua/api-mvp:d5f5db97f99e41c2a73d7be9cdc9ce8999e8c355"        
        env {
          name  = "DATABASE_HOST"
          value = google_sql_database_instance.db.public_ip_address
        }
        env {
          name  = "DATABASE_NAME"
          value = google_sql_database.schema_mvp.name
        }
        env {
          name  = "DATABASE_USERNAME"
          value = google_sql_user.user_mvp.name
        }
        env {
          name  = "DATABASE_PASSWORD"
          value = random_id.password_mvp.hex
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

resource "google_cloud_run_service_iam_member" "api_mvp" {
  service  = google_cloud_run_service.api_mvp.name
  location = google_cloud_run_service.api_mvp.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "api_mvp_url" {
  value = google_cloud_run_service.api_mvp.status[0].url
}

resource "google_cloud_run_service" "app_mvp" {
  name     = "app-mvp"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/cantodarua/app-mvp:test1"
        ports {
          container_port = 3000
        }
      }
    }
  }
  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "app_mvp" {
  service  = google_cloud_run_service.app_mvp.name
  location = google_cloud_run_service.app_mvp.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "app_mvp_url" {
  value = google_cloud_run_service.app_mvp.status[0].url
}
