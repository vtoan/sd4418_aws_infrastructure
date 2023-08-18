# ============= Resource Group =============
resource "random_pet" "rg_name" {
  prefix = var.rg_name_prefix
}

resource "azurerm_resource_group" "example" {
  name     = random_pet.rg_name.id
  location = var.rg_location
}

# ============= Network =============
resource "azurerm_virtual_network" "example" {
  name                = "example-aks-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = [var.virtual_network_address_prefix]

  subnet {
    name           = "kubesubnet"
    address_prefix = var.aks_subnet_address_prefix
  }
}

data "azurerm_subnet" "kubesubnet" {
  name                 = "kubesubnet"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.example.name
}

# ============= CONATINER REGISTRY =============
resource "random_pet" "acr_name" {
  prefix    = "exampleArc"
  separator = ""
  length    = 1
}

resource "azurerm_container_registry" "example" {
  name                = random_pet.acr_name.id
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Basic"
}

# ============= AKS =============
resource "random_pet" "aks_name" {
  prefix = "cluster"
}

resource "random_pet" "aks_name_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = random_pet.aks_name.id
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = random_pet.aks_name_dns_prefix.id

  http_application_routing_enabled = false

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = data.azurerm_subnet.kubesubnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    service_cidr       = var.aks_service_cidr
  }
}
