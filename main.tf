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
      "443", "80", "10050"
    ]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.zabbix_tag}"]
}

#===============================================
# Create zabbix server
#===============================================
resource "google_compute_instance" "zabbix" {
  name         = "app-zabbix"
  machine_type = "g1-small"
  zone         = "${var.zone_instance}"
  tags         = ["${var.zabbix_tag}"]

  # add image disk
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  # add network
  network_interface {
    network = "default"
    access_config {
    }
  }
  # ssh_key
  metadata = {
    sshKeys = "${var.default_user}:${file("~/.ssh/id_rsa.pub")}"
  }
  connection {
    host        = self.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "${var.default_user}"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  # provisioner "file" {
  #   source      = "scripts/setupzabbix.sh"
  #   destination = "~/setupzabbix.sh"
  # }

  metadata_startup_script = "${file("scripts/setupzabbix.sh")}"

  provisioner "file" {
    source      = "scripts/zabscripts"
    destination = "/usr/lib/zabbix/alertscripts "
  }

  provisioner "file" {
    source      = "scripts/zabconf"
    destination = "/etc/zabbix"
  }

}
