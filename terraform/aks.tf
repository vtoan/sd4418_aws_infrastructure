### ============= SETUP K8S =============
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
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}
