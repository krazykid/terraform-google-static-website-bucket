resource "random_uuid" "website_bucket_uuid" {}


resource "google_storage_bucket" "website_bucket" {
  project            = var.project_id
  name               = var.bucket_add_uuid ? "${local.website_bucket_base_name}-${random_uuid.website_bucket_uuid.result}" : local.website_bucket_base_name
  location           = var.bucket_location
  force_destroy      = true
  bucket_policy_only = true

  versioning {
    enabled = var.bucket_versioning
  }

  website {
    main_page_suffix = var.main_page_suffix
    not_found_page   = var.not_found_page
  }

  //  cors {
  //    origin          = [local.env_url]
  //    method          = ["GET", "PUT"]
  //    response_header = ["Content-Type"]
  //  }
}


resource "google_storage_bucket_iam_member" "allow_all_users" {
  bucket  = google_storage_bucket.website_bucket.name
  member  = "allUsers"
  role    = "roles/storage.legacyObjectReader"
}


resource "google_compute_backend_bucket" "lb_bucket_backend" {
  project     = var.project_id
  bucket_name = google_storage_bucket.website_bucket.name
  name        = local.backend_id
  description = local.backend_desc
  enable_cdn  = var.enable_cdn

  cdn_policy {
    signed_url_cache_max_age_sec = local.max_cache_age
  }

  depends_on = [
    google_storage_bucket_iam_member.allow_all_users
  ]
}


resource "google_compute_url_map" "website_url_map" {
  project         = var.project_id
  name            = local.url_map_id
  description     = local.url_map_desc
  default_service = google_compute_backend_bucket.lb_bucket_backend.self_link
}


resource "google_compute_managed_ssl_certificate" "website_certificate" {
  provider = "google-beta"
  project  = var.project_id

  name = local.cert_id

  managed {
    domains = local.fqdns
  }
}


resource "google_compute_target_https_proxy" "website_https_proxy" {
  project = var.project_id
  name    = local.https_proxy_id

  ssl_certificates = [
    google_compute_managed_ssl_certificate.website_certificate.self_link
  ]
  url_map          = google_compute_url_map.website_url_map.self_link
}


resource "google_compute_global_address" "website_public_address" {
  project      = var.project_id
  name         = local.public_addr_id
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}


resource "google_compute_global_forwarding_rule" "website_global_forwarding_rule" {
  project    = var.project_id
  name       = local.global_forwarding_rule_id
  target     = google_compute_target_https_proxy.website_https_proxy.self_link
  ip_address = google_compute_global_address.website_public_address.address
  port_range = "443"
}

