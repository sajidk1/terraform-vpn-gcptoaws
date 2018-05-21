### Setup routes and gateways ###
# Create address range on GCP 
resource "google_compute_address" "gcp-address" {
  name = "aws-vpn"
}

# Setup gateway on AWS for GCP address range
resource "aws_customer_gateway" "aws-cgw" {
  ip_address = "${google_compute_address.gcp-address.address}"
  bgp_asn    = 65000
  type       = "ipsec.1"

  tags {
    Name = "gcp-cgw"
  }
}

# Create a AWS VPN gateway
resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${var.awsvpcid}"

  tags {
    Name = "gcp-vgw"
  }
}

# Attach a route (gcp cidr) to our aws gateway
resource "aws_route" "route" {
  route_table_id         = "${var.awsroutetableid}"
  destination_cidr_block = "${var.gcpcidr}"
  gateway_id             = "${aws_vpn_gateway.vpn_gw.id}"
}

# Turn on route propogation for our gateway on our routetable
resource "aws_vpn_gateway_route_propagation" "route_propogation" {
  vpn_gateway_id = "${aws_vpn_gateway.vpn_gw.id}"
  route_table_id = "${var.awsroutetableid}"
}
