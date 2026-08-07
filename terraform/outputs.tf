output "project_id" {
  description = "Google Cloud project used by the deployment"

  value = local.project_id
}

output "region" {
  description = "Deployment region"

  value = var.region
}

output "firestore_database" {
  description = "Firestore database"

  value = google_firestore_database.database.name
}

output "artifact_registry_repository" {
  description = "Artifact Registry repository"

  value = google_artifact_registry_repository.app.name
}

output "container_image" {
  description = "Docker image currently deployed"

  value = local.image_uri
}

output "cloud_run_service" {
  description = "Cloud Run service name"

  value = google_cloud_run_v2_service.app.name
}

output "website_url" {
  description = "URL to program into the NFC tag"

  value = google_cloud_run_v2_service.app.uri
}
