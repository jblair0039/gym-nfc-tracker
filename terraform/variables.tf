variable "region" {
  description = "Google Cloud region used for the application"
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "Cloud Run service name"
  type        = string
  default     = "gym-nfc-tracker"
}

variable "repository_name" {
  description = "Artifact Registry repository name"
  type        = string
  default     = "gym-nfc-app"
}

variable "service_account_id" {
  description = "Cloud Run application service account ID"
  type        = string
  default     = "gym-nfc-app"
}
