resource "azurerm_public_ip" "vpngw_pip" {
  name                = "vpngw-pip"
  location            = azurerm_resource_group.capstone_rg.location
  resource_group_name = azurerm_resource_group.capstone_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}