locals {
  app_files = sort(
    tolist(
      fileset(
        "${path.module}/../app",
        "**"
      )
    )
  )

  source_hash = substr(
    sha256(
      join(
        "",
        [
          for file in local.app_files :
          filesha256("${path.module}/../app/${file}")
        ]
      )
    ),
    0,
    12
  )

  image_uri = "${var.region}-docker.pkg.dev/${local.project_id}/${var.repository_name}/${var.service_name}:${local.source_hash}"
}
