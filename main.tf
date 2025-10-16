#Resource Group
module "resource_group" {
  source = "./modules/rg"

  rg_name     = var.rg_name
  location = var.location
  /*
  labels = {
    environment = env_map[var.target_enviromnet]
  }
  tags = var.compute_storage_tags
  */
}

#App Service Plan
module "app_service_plan" {
  source = "./modules/asp"

  asp_name = var.asp_name
  rg_name = module.resource_group.rg_name
  location = module.resource_group.rg_location

  sku_name = var.sku_name
  os_type = var.os_type
}

#App Service
#using count variable 
resource "azurerm_windows_web_app" "wwa" {
  count = 2
  name                = "waa${count.index}"
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = module.app_service_plan.asp_id

  site_config {}
}

/*
resource "azurerm_windows_web_app" "wwa" {
  name                = var.wwa
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {}
}

resource "azurerm_windows_web_app" "wwa1" {
  name                = var.wwa1
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {}
}
*/

#Database Server - MySQL
resource "azurerm_mssql_server" "sqldb_server" {
  name                         = var.sqlserver
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.administrator_login //login name
  administrator_login_password = var.admin_password //login password
}

#Database
resource "azurerm_mssql_database" "sqldb" {
  name         = var.sqldb
  server_id    = azurerm_mssql_server.sqldb_server.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  //enclave_type = "VBS"

  tags = {
    foo = "bar"
  }

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}


#Vnet
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  address_space       = ["10.0.0.0/16"] //assign the address space
  location            = var.location
  resource_group_name = var.rg_name
}

#Subnet
resource "azurerm_subnet" "snet" {
  name                 = var.snet
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"] //assign address space
}

#Network interface card
resource "azurerm_network_interface" "nic" {
  name                = var.nic
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Virtual Machine
resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

#Network security group
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "test"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "test"
  }
}

#Subnet and NSG association
resource "azurerm_subnet_network_security_group_association" "nsg-snet" {
  subnet_id                 = azurerm_subnet.snet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}