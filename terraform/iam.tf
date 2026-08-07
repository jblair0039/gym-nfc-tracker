resource "google_service_account" "app" {
  project = local.project_id

  account_id = var.service_account_id

  display_name = "Gym NFC Tracker"

  description = "Service identity used by the Gym NFC Tracker Cloud Run application"

  depends_on = [
    google_project_service.required_apis
  ]
}
