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

output "database_schema_dev" {
  value = google_sql_database.schema_dev.name
}
