resource "google_artifact_registry_repository" "app" {
  project = local.project_id

  location = var.region

  repository_id = var.repository_name

  description = "Docker repository for the Gym NFC Tracker"

  format = "DOCKER"

  depends_on = [
    google_project_service.required_apis
  ]
}
