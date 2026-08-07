data "external" "gcloud_project" {
  program = [
    "bash",
    "-c",
    <<-EOT
      PROJECT_ID="$(gcloud config get-value project 2>/dev/null)"

      if [ -z "$PROJECT_ID" ] || [ "$PROJECT_ID" = "(unset)" ]; then
        echo '{"error":"No Google Cloud project is currently selected."}'
        exit 1
      fi

      printf '{"project_id":"%s"}\n' "$PROJECT_ID"
    EOT
  ]
}

locals {
  project_id = data.external.gcloud_project.result.project_id
}

provider "google" {
  project = local.project_id
  region  = var.region
}
