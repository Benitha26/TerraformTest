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
  enclave_type = "VBS"

  tags = {
    foo = "bar"
  }

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}