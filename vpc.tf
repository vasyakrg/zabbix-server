#===============================================
# Create firefall for all
#===============================================
resource "google_compute_firewall" "firewall_vpn" {
  name = "allow-zabbix"

  # name of net
  network = "default"

  allow {
    protocol = "tcp"
    ports = [
      "443", "80", "10050", "10051"
    ]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.zabbix_tag}"]
}
