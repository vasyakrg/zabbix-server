output "agent_ip" {
  value = "${google_compute_instance.agent.network_interface.0.access_config.0.nat_ip}"
}

output "zabbix_ip" {
  value = "${google_compute_instance.zabbix.network_interface.0.access_config.0.nat_ip}"
}
