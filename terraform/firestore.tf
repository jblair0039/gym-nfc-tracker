resource "google_firestore_database" "database" {
  project = local.project_id

  name = "(default)"

  location_id = var.region

  type = "FIRESTORE_NATIVE"

  app_engine_integration_mode = "DISABLED"

  delete_protection_state = "DELETE_PROTECTION_DISABLED"

  depends_on = [
    google_project_service.required_apis
  ]
}
