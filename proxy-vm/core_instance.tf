data "terraform_remote_state" "common" {
  backend = "remote"
  config = {
    organization = "[your organization name]"
    workspaces = {
      name = "common"
    }
  }
}

locals {
  common = data.terraform_remote_state.common.outputs
}

# ========================================================
# データソース (Data Sources: AD & Image)
# ========================================================
# 最初の Availability Domain を取得
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

# ========================================================
# VM インスタンス (Compute: Always Free Ampere A1)
# ========================================================
resource "oci_core_instance" "proxy_vm" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "proxy-vm"
  shape               = "VM.Standard.E2.1.Micro" # Always Free の最小スペック (1 OCPU / 1GB RAM)

  shape_config {
    ocpus         = 1
    memory_in_gbs = 1
  }

  source_details {
    source_type = "image"
    # Canonical-Ubuntu-24.04-2026.07.17-0  以下のサイトから、OCIDを取得する
    #   https://docs.oracle.com/en-us/iaas/images/index.htm
    source_id = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaayya4o7hej6uccychyziwbstlgpxhxnvbvee7luot7bk4alxjkmlq"
  }

  create_vnic_details {
    subnet_id        = local.common.proxy_subnet_id
    assign_public_ip = false # 手動で付与する事！
    display_name     = "primaryvnic"
    nsg_ids          = [local.common.proxy_nsg_id]
  }

  metadata = {
    ssh_authorized_keys = var.vm_ssh_public_key
  }

  preserve_boot_volume = false
}
