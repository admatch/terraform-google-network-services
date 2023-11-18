# Reserve an external IP
resource "google_compute_global_address" "external_ip_address" {
  name    = "ga-${var.environment}-${var.project_name}-lb-ip"
  project = var.project
}

# Create HTTPS certificate
resource "google_compute_managed_ssl_certificate" "ssl_certificate" {
  provider = google-beta
  name     = "cert-${var.environment}-${var.project_name}"
  project  = var.project
  managed {
    domains = [google_dns_record_set.dns_record_set.name]
  }
}

# Create the dns managed zone
resource "google_dns_managed_zone" "dns_zone_admatch" {
  name      = "dz-${var.environment_code}-${replace(var.dns_name, ".", "-")}"
  dns_name  = "${var.dns_name}."
  project   = var.project
}

# Add the IP to the DNS
resource "google_dns_record_set" "dns_record_set" {
  name         = google_dns_managed_zone.dns_zone_admatch.dns_name
  project      = var.project
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.dns_zone_admatch.name
  rrdatas      = [google_compute_global_address.external_ip_address.address]
}

# Add Network Endpoint Group to register serverless function as backend
resource "google_compute_region_network_endpoint_group" "network_endpoint_group" {
  count                 = var.cloud_function_name ? 1 : 0 
  provider              = google-beta
  project               = var.project
  name                  = "neg-${var.project_name}"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_function {
    function = var.cloud_function_name
  }
}

# Keep track of eligible backend
resource "google_compute_backend_service" "backend_service" {
  count       = var.cloud_function_name ? 1 : 0 
  name        = "bs-${var.environment}-${var.project_name}"
  project     = var.project
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30

  backend {
    group = google_compute_region_network_endpoint_group.network_endpoint_group.id
  }
}

# GCP URL MAP
resource "google_compute_url_map" "url_map" {
  name            = "um-${var.environment}-${var.project_name}"
  project         = var.project
  default_service = google_compute_backend_service.backend_service.id
}

# GCP target proxy
resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "hp-${var.environment}-${var.project_name}"
  project          = var.project
  url_map          = google_compute_url_map.url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_certificate.id]
}

# GCP forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name       = "lb-${var.environment}-${var.project_name}"
  project    = var.project
  target     = google_compute_target_https_proxy.https_proxy.id
  port_range = "443"
  ip_address = google_compute_global_address.external_ip_address.address
}
