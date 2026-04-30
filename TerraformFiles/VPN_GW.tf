resource "azurerm_virtual_network_gateway" "azure_vpngw" {
  name                = "Azure-VPN-Gateway"
  location            = azurerm_resource_group.capstone_rg.location
  resource_group_name = azurerm_resource_group.capstone_rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = "VpnGw1" 

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpngw_pip.id
    private_ip_address_allocation = "Dynamic"
    # Reference to the GatewaySubnet defined in vnet.tf
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
}

resource "azurerm_local_network_gateway" "onprem_pfsense" {
  name                = "OnPrem-pfSense"
  location            = azurerm_resource_group.capstone_rg.location
  resource_group_name = azurerm_resource_group.capstone_rg.name
  
  # Your actual home public IP address
  gateway_address     = "YOUR_HOME_PUBLIC_IP" 

  # This identifies your HOME network to Azure
  address_space       = ["10.0.0.0/16"] 
}