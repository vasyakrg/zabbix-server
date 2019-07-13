#===============================================
# Create PVE servers
#===============================================
resource "google_compute_instance" "agent" {
  name         = "agent-1"
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

  provisioner "remote-exec" {
    inline = ["${file("scripts/setupagent.sh")}"]
  }

  provisioner "file" {
    source      = "scripts/agents/zabbix_agentd.conf"
    destination = "~/zabbix_agentd.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y",
      "sudo echo ${self.name} >> /var/www/html/index.nginx-debian.html",
      "sudo systemctl enable nginx && sudo systemctl start nginx",
      "sudo cp ~/zabbix_agentd.conf /etc/zabbix/",
      "sudo service zabbix-agent restart"
    ]
  }
}
