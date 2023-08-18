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

# ======= Network =======
variable "virtual_network_address_prefix" {
  type        = string
  description = "VNET address prefix"
  default     = "192.168.0.0/16"
}

variable "aks_subnet_address_prefix" {
  type        = string
  description = "Subnet address prefix."
  default     = "192.168.0.0/24"
}

variable "app_gateway_subnet_address_prefix" {
  type        = string
  description = "Subnet server IP address."
  default     = "192.168.1.0/24"
}

variable "app_gateway_sku" {
  type        = string
  description = "Name of the Application Gateway SKU"
  default     = "Standard_v2"
}

variable "app_gateway_tier" {
  type        = string
  description = "Tier of the Application Gateway tier"
  default     = "Standard_v2"
}

# ======= AKS NETWORK =======
variable "aks_docker_bridge_cidr" {
  type        = string
  description = "CIDR notation IP for Docker bridge."
  default     = "172.17.0.1/16"
}

variable "aks_dns_service_ip" {
  type        = string
  description = "DNS server IP address"
  default     = "10.0.0.10"
}

variable "aks_service_cidr" {
  type        = string
  description = "CIDR notation IP range from which to assign service cluster IPs"
  default     = "10.0.0.0/16"
}
