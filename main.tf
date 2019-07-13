#===============================================
# Create zabbix server
#===============================================
resource "google_compute_instance" "zabbix" {
  name         = "app-zabbix"
  machine_type = "g1-small"
  zone         = "${var.zone_instance}"
  tags         = ["${var.zabbix_tag}"]

  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata = {
    sshKeys = "${var.default_user}:${file("~/.ssh/id_rsa.pub")}"
  }
  connection {
    host        = self.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "${var.default_user}"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "scripts/setupzabbix.sh"
    destination = "~/setupzabbix.sh"
  }

  provisioner "file" {
    source      = "scripts/zabconf"
    destination = "~/"
  }

  # provisioner "remote-exec" {
  #   inline = ["${file("scripts/setupzabbix.sh")}"]
  # }
}
