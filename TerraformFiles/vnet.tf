resource "azurerm_virtual_network" "cloud_vnet" {
  name                = "CloudVnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.capstone_rg.location
  resource_group_name = azurerm_resource_group.capstone_rg.name

  tags = {
    Project = "Capstone"
  }
}

# Subnet for the VPN Gateway
resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.capstone_rg.name
  virtual_network_name = azurerm_virtual_network.cloud_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Subnet for the Cloud Servers
resource "azurerm_subnet" "cloud_server_subnet" {
  name                 = "CloudServerSubnet"
  resource_group_name  = azurerm_resource_group.capstone_rg.name
  virtual_network_name = azurerm_virtual_network.cloud_vnet.name
  address_prefixes     = ["10.1.2.0/24"]
}