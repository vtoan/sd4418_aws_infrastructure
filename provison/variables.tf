variable "rg_location" {
  type    = string
  default = "eastus2"
}

variable "rg_name_prefix" {
  type    = string
  default = "test-rg"
}

variable "az_client_secret" {
  type      = string
  sensitive = true
}

variable "az_client_id" {
  type = string
}

variable "az_sub_id" {
  type = string
}

variable "az_tenant_id" {
  type = string
}

