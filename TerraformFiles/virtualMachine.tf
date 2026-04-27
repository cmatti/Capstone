data "azurerm_image" "custom_base" {
  name                = "ubuntu-gns3-base-image"
  resource_group_name = azurerm_resource_group.primary.name
}

# 1. Create a Standard Public IP (Required for North Central US)
resource "azurerm_public_ip" "pip" {
  name                = "pip-ubuntu-vm"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  sku                 = "Standard"
  allocation_method   = "Static"
}

# 2. Create the Network Interface (NIC) attached to your 10.100.1.0/24 subnet
resource "azurerm_network_interface" "nic" {
  name                = "nic-ubuntu-vm"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# 3. Create the Ubuntu 24.04 VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-ubuntu-capstone"
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location
  size                = "Standard_D8s_v3"
  admin_username      = "azureuser"
  
  # Matches "Standard" security type from your screenshot
  secure_boot_enabled = false
  vtpm_enabled        = false

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  # Authentication using the local key we verified earlier
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("/home/chris/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "osdisk-ubuntu-capstone"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Image reference for Ubuntu 24.04 LTS Gen2
  source_image_id = data.azurerm_image.custom_base.id
}
