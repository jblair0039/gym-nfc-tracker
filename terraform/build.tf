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

      echo "Configuring Docker authentication..."

      gcloud auth configure-docker \
        ${var.region}-docker.pkg.dev \
        --quiet

      echo "Building Docker image..."

      docker build \
        -t "${local.image_uri}" \
        "${path.module}/../app"

      echo "Pushing Docker image..."

      docker push \
        "${local.image_uri}"

      echo "Docker image successfully pushed."
    EOT
  }

  depends_on = [
    google_artifact_registry_repository.app
  ]
}
