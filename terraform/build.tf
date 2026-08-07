resource "terraform_data" "build_app" {
  triggers_replace = [
    local.source_hash
  ]

  provisioner "local-exec" {
    interpreter = [
      "/bin/bash",
      "-c"
    ]

    command = <<-EOT
      set -e

      echo "Submitting application to Google Cloud Build..."

      gcloud builds submit \
        "${path.module}/../app" \
        --project="${local.project_id}" \
        --region="${var.region}" \
        --tag="${local.image_uri}" \
        --quiet

      echo "Cloud Build completed successfully."
    EOT
  }

  depends_on = [
    google_artifact_registry_repository.app,
    google_project_service.required_apis
  ]
}
