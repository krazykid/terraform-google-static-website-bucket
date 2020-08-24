output "website_bucket_name" {
  value = google_storage_bucket.website_bucket.name
}

output "website_bucket_url" {
  value = google_storage_bucket.website_bucket.url
}

output "website_public_ip" {
  value = google_compute_global_address.website_public_address.address
}

output "website_ssl_certificate_sans" {
  value = google_compute_managed_ssl_certificate.website_certificate.subject_alternative_names
}