#===============================================
# Create PVE servers
#===============================================
resource "google_compute_instance" "pve" {
  count        = "${var.count_instance}"
  name         = "serv-${count.index + 1}"
  machine_type = "g1-small"
  zone         = "${var.zone_instance}"
  tags         = ["serv-${count.index + 1}"]

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

  metadata_startup_script = "${file("scripts/setupagent.sh")}"

  connection {
    host        = self.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "${var.default_user}"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "scripts/agents/zabbix_agent.conf"
    destination = "/etc/zabbix/zabbix_agent.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y",
      "sudo echo Serv-${count.index + 1} >> /var/www/html/index.nginx-debian.html",
      "sudo systemctl enable nginx && sudo systemctl start nginx"
    ]
  }

}
