terraform {
  backend "gcs" {
    bucket = "cantodarua_tfstate"
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project
}

resource "google_sql_database_instance" "db" {
  name                = "${var.project}-mysql-2"
  database_version    = "MYSQL_8_0"
  region              = var.region
  deletion_protection = false

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = "true"
      authorized_networks {
        value = "0.0.0.0/0"
      }
    }

  }
}

output "database_public_ip" {
  value = google_sql_database_instance.db.public_ip_address
}

resource "google_sql_database" "schema" {
  name     = "${var.project}-db"
  project  = var.project
  instance = google_sql_database_instance.db.name
}

resource "random_id" "password" {
  byte_length = 16
}

resource "google_sql_user" "user" {
  name     = "${var.project}-user"
  project  = var.project
  instance = google_sql_database_instance.db.name
  host     = "%"
  password = random_id.password.hex
}

output "database_credentials" {
  value = {
    user = google_sql_user.user.name
    pass = random_id.password.hex
  }
}

resource "google_cloud_run_service" "api" {
  name     = "api"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/cantodarua/api:0f7df278c0683c590812a14eb3bb9054c0b9bcc6"
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

resource "google_cloud_run_service_iam_member" "api" {
  service  = google_cloud_run_service.api.name
  location = google_cloud_run_service.api.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "api_url" {
  value = google_cloud_run_service.api.status[0].url
}
