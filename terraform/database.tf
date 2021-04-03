resource "google_sql_database_instance" "db" {
  name             = "cantodarua-db"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}

output "db_name" {
  value = google_sql_database_instance.db.name
}