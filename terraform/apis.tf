resource "google_project_service" "required_apis" {
  for_each = toset([
    "artifactregistry.googleapis.com",
    "firestore.googleapis.com",
    "iam.googleapis.com",
    "run.googleapis.com"
  ])

  project = local.project_id

  service = each.value

  disable_on_destroy = false
}
