resource "oci_core_vcn" "proxy_vcn" {
  compartment_id = var.compartment_ocid
  cidr_blocks    = [local.vcn_proxy_vpc.vcn_cidr]
  display_name   = local.vcn_proxy_vpc.name
  dns_label      = "proxyvcn"
  freeform_tags  = local.common_tags
}

resource "oci_core_subnet" "proxy_vcn_subnet" {
  for_each = local.vcn_proxy_vpc.subnet

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.proxy_vcn.id
  display_name   = each.key

  cidr_block     = each.value.cidr_block
  route_table_id = oci_core_route_table.proxy_rt.id

  prohibit_internet_ingress  = each.value.prohibit_internet_ingress
  prohibit_public_ip_on_vnic = each.value.prohibit_public_access
  freeform_tags              = local.common_tags
}

resource "oci_core_internet_gateway" "proxy_igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.proxy_vcn.id
  display_name   = "${local.vcn_proxy_vpc.name}-igw"
  freeform_tags  = local.common_tags
}

resource "oci_core_route_table" "proxy_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.proxy_vcn.id
  display_name   = "${local.vcn_proxy_vpc.name}-rt"
  freeform_tags  = local.common_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.proxy_igw.id
  }
}

# デフォルトの Security List をロックダウンする
resource "oci_core_default_security_list" "default_security_list_lockdown" {
  manage_default_resource_id = oci_core_vcn.proxy_vcn.default_security_list_id
  freeform_tags              = local.common_tags
  # ingress_security_rules や egress_security_rules を記述しない（または空にする）
}

# 予約パブリック IP (固定IP)
resource "oci_core_public_ip" "proxy_reserved_ip" {
  compartment_id = var.compartment_ocid
  lifetime       = "RESERVED"
  display_name   = "${local.vcn_proxy_vpc.name}-reserved-ip"
  freeform_tags  = local.common_tags

  lifecycle {
    ignore_changes = [
      private_ip_id, # 予約IPの変更は無視する
    ]
  }
}
