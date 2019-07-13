#===============================================
# Create A records to AWS
#===============================================
data "aws_route53_zone" "dns_zone" {
  name = "${var.dns_zone_name}"
}

resource "aws_route53_record" "zabbix" {
  zone_id = "${data.aws_route53_zone.dns_zone.id}"
  name    = "zabbix"
  type    = "A"
  ttl     = "300"
  records = ["${google_compute_instance.zabbix.network_interface.0.access_config.0.nat_ip}"]
}

resource "aws_route53_record" "zabbix-agents" {
  zone_id = "${data.aws_route53_zone.dns_zone.id}"
  name    = "agent-1"
  type    = "A"
  ttl     = "300"
  records = ["${google_compute_instance.agent.network_interface.0.access_config.0.nat_ip}"]
}
