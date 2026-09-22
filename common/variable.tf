variable "compartment_ocid" {
  type      = string
  sensitive = true
}

variable "tenancy_ocid" {
  type      = string
  sensitive = true
}

variable "user_ocid" {
  type      = string
  sensitive = true
}

variable "private_key" {
  type      = string
  sensitive = true
}

variable "fingerprint" {
  type      = string
  sensitive = true
}

variable "vm_ssh_public_key" {
  type      = string
  sensitive = true
}
