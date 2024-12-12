#Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-ben-tst-001"
  location = "East US"
}

resource "azurerm_app_service_plan" "asp" {
  name                = "asp-ben-wus-tst"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

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