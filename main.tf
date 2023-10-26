resource "azurerm_resource_group" "rg_abranteme" {
    name     = "rg-${var.prefix}"
    location = var.location
}

