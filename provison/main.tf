# ============= Resource Group =============
resource "random_pet" "rg_name" {
  prefix = var.rg_name_prefix
}

resource "azurerm_resource_group" "example" {
  name     = random_pet.rg_name.id
  location = var.rg_location
}

# Locals block for hardcoded names
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.example.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.example.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.example.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.example.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.example.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.example.name}-rqrt"
  app_gateway_subnet_name        = "appgwsubnet"
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

  subnet {
    name           = "appgwsubnet"
    address_prefix = var.app_gateway_subnet_address_prefix
  }
}

data "azurerm_subnet" "kubesubnet" {
  name                 = "kubesubnet"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.example.name
}

data "azurerm_subnet" "appgwsubnet" {
  name                 = "appgwsubnet"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.example.name
}


resource "azurerm_public_ip" "example" {
  name                = "example-public-ip1"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "network" {
  name                = var.app_gateway_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  sku {
    name     = var.app_gateway_sku
    tier     = var.app_gateway_tier
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = data.azurerm_subnet.appgwsubnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.example.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1
  }
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

  http_application_routing_enabled = false

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
    vnet_subnet_id  = data.azurerm_subnet.kubesubnet.id
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