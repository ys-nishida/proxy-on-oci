resource "oci_core_network_security_group" "proxy_nsg" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.proxy_vcn.id
  display_name   = "${local.vcn_proxy_vpc.name}-nsg"
  freeform_tags  = local.common_tags
}

# アウトバウンドルール (すべての通信を許可)
resource "oci_core_network_security_group_security_rule" "proxy_egress" {
  network_security_group_id = oci_core_network_security_group.proxy_nsg.id

  direction        = "EGRESS"
  protocol         = "all"
  destination      = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
  stateless        = false

  description = "Egress rule to allow all outbound traffic"
}

# インバウンドルール (for_each で動的生成)
resource "oci_core_network_security_group_security_rule" "from_home1" {
  for_each = local.nsg_ingress_rules.from_home1.ports

  network_security_group_id = oci_core_network_security_group.proxy_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  stateless                 = false
  description               = each.value.description

  source      = local.nsg_ingress_rules.from_home1.source_ip
  source_type = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = each.value.port
      max = each.value.port
    }
  }
}
resource "oci_core_network_security_group_security_rule" "from_home2" {
  for_each = local.nsg_ingress_rules.from_home2.ports

  network_security_group_id = oci_core_network_security_group.proxy_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  stateless                 = false
  description               = each.value.description

  source      = local.nsg_ingress_rules.from_home2.source_ip
  source_type = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = each.value.port
      max = each.value.port
    }
  }
}
