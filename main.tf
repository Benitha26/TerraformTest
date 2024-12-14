#Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-ben-tst-001"
  location = "East US"
}

#App Service Plan
resource "azurerm_app_service_plan" "asp" {
  name                = "asp-ben-wus-tst"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

#App Service
resource "azurerm_app_service" "as" {
  name                = "ase-ben-wus-tst-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "App-settings-Key" = "App settings value" //Key-value pair of app settings
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}

#Database Server - MySQL
resource "azurerm_mssql_server" "sqldb_server" {
  name                         = "dbs-ben-wus-tst"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "login name" //login name
  administrator_login_password = "password" //login password
}

#Database
resource "azurerm_mssql_database" "sqldb" {
  name         = "db-ben-wus-tst"
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
  name                = "vn-ben-wus-tst-001"
  address_space       = ["10.0.0.0/16"] //assign the address space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

#Subnet
resource "azurerm_subnet" "snet" {
  name                 = "sn-ben-wus-tst-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"] //assign address space
}

#Network interface card
resource "azurerm_network_interface" "nic" {
  name                = "nic-01-vmben-tst-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Virtual Machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "vm-ben-tst-001"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
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
  name                = "nsg-bentst-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

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