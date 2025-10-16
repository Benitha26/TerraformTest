resource "azurerm_service_plan" "asp" {
  name                = var.asp_name
  location            = var.location
  resource_group_name = var.rg_name

  sku_name            = var.sku_name
  os_type             = var.os_type 
} 