variable "project_id" {
  type = string
}

variable "base_id" {
  type = string
}

variable "base_name" {
  type = string
}

variable "bucket_add_uuid" {
  type    = bool
  default = true
}

variable "bucket_location" {
  type    = string
  default = "US"
}

variable "bucket_versioning" {
  type    = bool
  default = true
}

variable "main_page_suffix" {
  type    = string
  default = "index.html"
}

variable "not_found_page" {
  type    = string
  default = "404.html"
}

variable "fqdns" {
  type = list(string)
}

variable "enable_cdn" {
  type = bool
  default = true
}

variable "max_cache_age" {
  type = number
  default = 3600
}

locals {
  website_bucket_base_name  = "${var.base_id}-website"
  backend_id                = "${var.base_id}-backend"
  backend_desc              = "${var.base_name} Backend"
  url_map_id                = "${var.base_id}-url-map"
  url_map_desc              = "URL map to ${var.base_name} bucket/backend"
  cert_id                   = "${var.base_id}-cert"
  fqdns                     = var.fqdns
  https_proxy_id            = "${var.base_id}-https-proxy"
  public_addr_id            = "${var.base_id}-public-address"
  global_forwarding_rule_id = "${var.base_id}-global-fowarding-rule"
  enable_cdn = var.enable_cdn
  max_cache_age = var.max_cache_age
}
