resource "google_service_account" "app" {
  project = local.project_id

  account_id   = var.service_account_id
  display_name = "Gym NFC Tracker"

  description = "Service identity used by the Gym NFC Tracker Cloud Run application"

  depends_on = [
    google_project_service.required_apis
  ]
}


resource "google_project_iam_member" "firestore_access" {
  project = local.project_id

  role = "roles/datastore.user"

  member = "serviceAccount:${google_service_account.app.email}"

  depends_on = [
    google_service_account.app,
    google_firestore_database.database
  ]
}
