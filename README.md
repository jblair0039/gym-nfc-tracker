# Gym NFC Tracker

A mobile-friendly NFC gym check-in application hosted on Google Cloud.

The application records:

- Name
- Current weight
- Current blood pressure
- Server timestamp
- Client timestamp

## Architecture

NFC Tag
→ Cloud Run
→ Flask
→ Firestore

Infrastructure is managed entirely with Terraform.

Terraform creates:

- Required Google APIs
- Artifact Registry
- Firestore Native database
- Cloud Run service account
- IAM permissions
- Docker image
- Cloud Run service

## Requirements

An existing Google Cloud project with billing enabled.

Deployment is intended to be performed from Google Cloud Shell.

Cloud Shell includes:

- gcloud
- Docker
- Terraform
- Git

## First Deployment

Clone the repository:

```bash
git clone https://github.com/YOUR-USERNAME/gym-nfc-tracker.git
