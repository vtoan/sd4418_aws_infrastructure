resource "random_pet" "rg_name" {
  prefix = var.rg_name_prefix
}

resource "azurerm_resource_group" "example" {
  name     = random_pet.rg_name.id
  location = var.rg_location
}
