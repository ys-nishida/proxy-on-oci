output "proxy_reserved_ip_id" {
  value = oci_core_public_ip.proxy_reserved_ip.id
}

output "proxy_subnet_id" {
  value = oci_core_subnet.proxy_vcn_subnet["vpc-subnet-01"].id
}

output "proxy_nsg_id" {
  value = oci_core_network_security_group.proxy_nsg.id
}
