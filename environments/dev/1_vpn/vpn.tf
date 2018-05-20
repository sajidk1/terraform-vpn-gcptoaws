### VPN ###
# Setup vpn on AWS side, passing the gateway and customer gateway ids
resource "aws_vpn_connection" "aws_vpn" {
  vpn_gateway_id      = "${aws_vpn_gateway.vpn_gw.id}"
  customer_gateway_id = "${aws_customer_gateway.aws-cgw.id}"
  type                = "ipsec.1"
  static_routes_only  = true
}

# Attach the gcp cide route to the vpn
resource "aws_vpn_connection_route" "vpn_route" {
  destination_cidr_block = "${var.gcpcidr}"
  vpn_connection_id      = "${aws_vpn_connection.aws_vpn.id}"
}

# Setup vpn on google side
resource "google_compute_vpn_gateway" "gcp_target_gateway" {
  name    = "gcp-aws"
  network = "default"
}

# Forwarding rules
resource "google_compute_forwarding_rule" "fr1_esp" {
  name        = "fr1-esp"
  ip_protocol = "ESP"
  ip_address  = "${google_compute_address.gcp-address.address}"
  target      = "${google_compute_vpn_gateway.gcp_target_gateway.self_link}"
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500-500"
  ip_address  = "${google_compute_address.gcp-address.address}"
  target      = "${google_compute_vpn_gateway.gcp_target_gateway.self_link}"
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500-4500"
  ip_address  = "${google_compute_address.gcp-address.address}"
  target      = "${google_compute_vpn_gateway.gcp_target_gateway.self_link}"
}

# VPN Tunnel
resource "google_compute_vpn_tunnel" "gcp-tunnel" {
  name          = "gcp-tunnel"
  peer_ip       = "${aws_vpn_connection.aws_vpn.tunnel1_address}"
  shared_secret = "${aws_vpn_connection.aws_vpn.tunnel1_preshared_key}"
  ike_version   = 1

  target_vpn_gateway = "${google_compute_vpn_gateway.gcp_target_gateway.self_link}"

  depends_on = [
    "google_compute_forwarding_rule.fr1_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
  ]
}

# Attach aws cidr route to VPN tunnel
resource "google_compute_route" "route1" {
  name       = "route1"
  network    = "default"
  dest_range = "${var.awscidr}"
  priority   = 1000

  next_hop_vpn_tunnel = "${google_compute_vpn_tunnel.gcp-tunnel.self_link}"
}
