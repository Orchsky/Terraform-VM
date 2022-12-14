# This is the environment where all your resources will be organized into
resource "azurerm_resource_group" "demo-rg" {
  name     = "demo-tf-vm"
  location = "East US"
}

# This block is like VPC
resource "azurerm_virtual_network" "demo-vnet" {
  name                = "demo-vnet"
  address_space       = [var.vnet]
  location            = azurerm_resource_group.demo-rg.location
  resource_group_name = azurerm_resource_group.demo-rg.name
}

# This is the same as AWS subnet
resource "azurerm_subnet" "demo-subnet" {
  name                 = "demo-subnet"
  resource_group_name  = azurerm_resource_group.demo-rg.name
  virtual_network_name = azurerm_virtual_network.demo-vnet.name
  address_prefixes     = [var.subnet]
}

# Need this in order to make vm publicly accessible
resource "azurerm_public_ip" "demo-public-ip" {
  name                = "demo-public-ip"
  resource_group_name = azurerm_resource_group.demo-rg.name
  location            = azurerm_resource_group.demo-rg.location
  allocation_method   = "Dynamic"
}

# This is the same thing as IGW 
resource "azurerm_network_interface" "demo-nic" {
  name                = "demo-nic"
  location            = azurerm_resource_group.demo-rg.location
  resource_group_name = azurerm_resource_group.demo-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.demo-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo-public-ip.id
  }
}

# This is the same as security group in AWS
resource "azurerm_network_security_group" "demo-nsg" {
  name                = "ssh-nsg"
  location            = azurerm_resource_group.demo-rg.location
  resource_group_name = azurerm_resource_group.demo-rg.name

  security_rule {
    name                       = "allow-ssh-sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Attachment for security group to NIC (IGW) / there is an alternative to attach to subnet instead
resource "azurerm_network_interface_security_group_association" "demo-association" {
  network_interface_id      = azurerm_network_interface.demo-nic.id
  network_security_group_id = azurerm_network_security_group.demo-nsg.id
}

resource "tls_private_key" "demo-ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Like EC2 instance
resource "azurerm_linux_virtual_machine" "demo-vm" {
  name                = "demo-vm"
  resource_group_name = azurerm_resource_group.demo-rg.name
  location            = azurerm_resource_group.demo-rg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.demo-nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.demo-ssh.public_key_openssh
  }

  # Think of this as EBS in EC2 configurations
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

output "tls_private_key" {
  value     = tls_private_key.demo-ssh.private_key_pem
  sensitive = true
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.demo-vm.public_ip_address
}