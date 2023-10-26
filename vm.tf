# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
    name = "rede-${var.prefix}"
    address_space = ["10.0.0.0/16"]
    location = var.location
    resource_group_name = azurerm_resource_group.rg_abranteme.name
}

# Create Subnet
resource "azurerm_subnet" "subnet" {
    name = "subnet-${var.prefix}"
    resource_group_name = azurerm_resource_group.rg_abranteme.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.1.0/24"]
}

# Create Public IP
resource "azurerm_public_ip" "publicip" {
    name = "ipPublico-${var.prefix}"
    location = var.location
    resource_group_name = azurerm_resource_group.rg_abranteme.name
    allocation_method = "Static"
}

# Create Security Group
resource "azurerm_network_security_group" "nsg" {
    name = "nsg-${var.prefix}"
    location = var.location
    resource_group_name = azurerm_resource_group.rg_abranteme.name

    security_rule {
        name = "SSH"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

# Create Network Interface
resource "azurerm_network_interface" "nic" {
    name = "nic-${var.prefix}"
    location = var.location
    resource_group_name = azurerm_resource_group.rg_abranteme.name

    ip_configuration {
        name = "ipconfig-${var.prefix}"
        subnet_id = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.publicip.id
    }
}

# Create Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${var.prefix}"
  resource_group_name = azurerm_resource_group.rg_abranteme.name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.administrator_login
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  connection {
    type = "ssh"
    host = azurerm_public_ip.publicip.ip_address
    user = var.administrator_login
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y curl",
    ]
  }

  provisioner "file" {
    source      = "files/pkgs.sh"
    destination = "/home/${var.administrator_login}/pkgs.sh"
  }

  provisioner "file" {
    source      = "files/docker-compose.yml"
    destination = "/home/${var.administrator_login}/docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.administrator_login}/pkgs.sh",
      "sudo /home/${var.administrator_login}/pkgs.sh",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker-compose -f /home/${var.administrator_login}/docker-compose.yml up -d",
    ]
  }

  provisioner "local-exec" {
    command = <<-EOT
        cat > index.html <<-EOF
        <html>
            <meta charset='utf-8'>
            <body>
                <h1>Olá, Terraform</h1>
            </body>
        </html>
        EOF
        EOT
  }

  provisioner "remote-exec" {
    inline = [
        "sudo chown -R ${var.administrator_login}:${var.administrator_login} /home/${var.administrator_login}/storage_app",
     ]
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/home/${var.administrator_login}/storage_app/index.html"
  }

  admin_ssh_key {
    username   = var.administrator_login
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "disk-${var.prefix}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}