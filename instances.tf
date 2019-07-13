#===============================================
# Create PVE servers
#===============================================
resource "google_compute_instance" "agent" {
  name         = "agent-1"
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
    source      = "scripts/agents/zabbix_agentd.conf"
    destination = "~/zabbix_agentd.conf"
  }

  provisioner "file" {
    source      = "scripts/setupagent.sh"
    destination = "~/setupagent.sh"
  }

  # provisioner "remote-exec" {
  #   inline = ["${file("scripts/setupagent.sh")}"]
  # }
}
