resource "google_cloud_run_v2_service" "app" {
  project  = local.project_id
  name     = var.service_name
  location = var.region

  description = "NFC Gym Check-In and Fitness Tracker"

  deletion_protection = false

  ingress = "INGRESS_TRAFFIC_ALL"

  invoker_iam_disabled = true

  template {
    service_account = google_service_account.app.email

    scaling {
      min_instance_count = 0
      max_instance_count = 3
    }

    containers {
      image = local.image_uri

      ports {
        container_port = 8080
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }

      env {
        name  = "GOOGLE_CLOUD_PROJECT"
        value = local.project_id
      }

      env {
        name  = "FIRESTORE_DATABASE"
        value = google_firestore_database.database.name
      }
    }
  }

  depends_on = [
    terraform_data.build_app,
    google_firestore_database.database,
    google_project_iam_member.firestore_access
  ]
}
