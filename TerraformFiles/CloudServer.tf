# 1. Create the Network Interface (No Public IP)
resource "azurerm_network_interface" "cloud_server_nic" {
  name                = "cloud-server-nic"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name

  ip_configuration {
    name                          = "internal"
    # References the second subnet block in your network.tf
    subnet_id                     = azurerm_subnet.internal[1].id
    private_ip_address_allocation = "Dynamic"
  }
}

# 2. Create the Ubuntu Virtual Machine
resource "azurerm_linux_virtual_machine" "cloud_server" {
  name                = "cloud-server"
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location
  size                = "Standard_D8s_v3"
  admin_username      = "adminuser"
  
  network_interface_ids = [
    azurerm_network_interface.cloud_server_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS" # Standard_D8s_v3 supports Premium Storage
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}