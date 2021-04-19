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

output "database_instance" {
  value = google_sql_database_instance.db.name
}

output "database_schema" {
  value = google_sql_database.schema.name
}
