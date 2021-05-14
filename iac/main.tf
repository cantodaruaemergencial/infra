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

module "db_schema" {
  source = "./modules/mysql_schema"

  project                = var.project
  name                   = "${var.project}-db"
  database_instance_name = google_sql_database_instance.db.name
}

output "db_schema" {
  value = module.db_schema.credentials
}

module "api" {
  source = "./modules/cloud_run"

  project               = var.project
  region                = var.region
  name                  = "api"
  image                 = "gcr.io/cantodarua/api:0f7df278c0683c590812a14eb3bb9054c0b9bcc6"
  url                   = "api.cantodaruaemergencial.com.br"
  dns_managed_zone_name = var.dns_managed_zone_name

  env_vars = [
    {
      name  = "DATABASE_HOST"
      value = google_sql_database_instance.db.public_ip_address
    },
    {
      name  = "DATABASE_NAME"
      value = module.db_schema.credentials.name
    },
    {
      name  = "DATABASE_USERNAME"
      value = module.db_schema.credentials.user
    },
    {
      name  = "DATABASE_PASSWORD"
      value = module.db_schema.credentials.pass
    },
    {
      name  = "GOOGLE_CLIENT_ID"
      value = var.google_client_id
    },
    {
      name  = "GOOGLE_CLIENT_SECRET"
      value = var.google_client_secret
    }
  ]
}

output "api" {
  value = module.api.urls
}