#Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-ben-tst-001"
  location = "East US"
}