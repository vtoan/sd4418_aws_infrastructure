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
  name                = "example-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ============= CONATINER REGISTRY =============
resource "random_pet" "acr_name" {
  prefix    = "exampleArc"
  separator = ""
  length = 1
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

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}