### ============= SETUP CONATINER REGISTRY =============
resource "random_pet" "acr_name" {
  prefix    = "exampleArc"
  separator = ""
}
resource "azurerm_container_registry" "example" {
  name                = random_pet.acr_name.id
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Basic"
  admin_enabled       = false
}
