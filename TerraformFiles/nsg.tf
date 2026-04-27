# Create the Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-capstone"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name

  security_rule {
    name                       = "Allow-SSH-RDP-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "3389"]
    source_address_prefix      = "24.128.175.25/32"
    destination_address_prefix = "*"
  }
}

# Associate the NSG with the Subnet defined in network.tf
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
