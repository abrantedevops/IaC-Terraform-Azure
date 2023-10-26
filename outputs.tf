output "name" {
    value = azurerm_resource_group.rg_abranteme.name 
}

output "location" {
    value = azurerm_resource_group.rg_abranteme.location
}

output "public_ip_address" {
    value = azurerm_public_ip.publicip.ip_address 
}