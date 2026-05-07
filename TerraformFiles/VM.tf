# Create the Network Interface
resource "azurerm_network_interface" "cloud_server_nic" {
  name                = "cloud-server-nic"
  location            = azurerm_resource_group.capstone_rg.location
  resource_group_name = azurerm_resource_group.capstone_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.cloud_server_subnet.id
    private_ip_address_allocation = "Dynamic"
    # No public_ip_address_id means no PIP is created
  }
}

# Create the Ubuntu Virtual Machine
resource "azurerm_linux_virtual_machine" "cloud_server" {
  name                = "CloudServer"
  resource_group_name = azurerm_resource_group.capstone_rg.name
  location            = azurerm_resource_group.capstone_rg.location
  size                = "Standard_D8s_v3"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.cloud_server_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    # This points to the file you just generated in this folder
    public_key = file("${path.module}/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    Environment = "Capstone"
  }
}