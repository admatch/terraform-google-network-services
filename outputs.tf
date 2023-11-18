output "lb_ip_address" {
    value       = google_compute_global_address.external_ip_address.address
    description = "The external IP address of the load balancer."
}