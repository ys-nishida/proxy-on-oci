terraform {
  required_version = ">= 1.15.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 8.25.0"
    }
  }

  # HCP Terraform 設定
  cloud {
    organization = "[your organization name]"
    workspaces {
      name = "proxy-vm"
    }
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
  region       = "ap-tokyo-1"
}
