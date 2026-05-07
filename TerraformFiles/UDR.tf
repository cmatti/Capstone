# Create the Route Table
resource "azurerm_route_table" "cloudserver_udr" {
  name                          = "CloudServer-UDR"
  location                      = azurerm_resource_group.capstone_rg.location
  resource_group_name           = azurerm_resource_group.capstone_rg.name
  bgp_route_propagation_enabled = true

  # Define the Forced Tunneling Route
  route {
    name           = "RT-Forced-Tunneling"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualNetworkGateway"
  }

  tags = {
    Environment = "Capstone"
  }
}

# Associate the Route Table with the CloudServerSubnet
resource "azurerm_subnet_route_table_association" "udr_assoc" {
  subnet_id      = azurerm_subnet.cloud_server_subnet.id
  route_table_id = azurerm_route_table.cloudserver_udr.id
}