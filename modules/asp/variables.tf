variable "asp_name" {
  default = "asp-ben-wus-tst"
  type = string
  description = "name of the app service plan"
}

variable "location" {
  description = "Azure region for the App Service Plan"
  type        = string
}

variable "rg_name" {
  description = "The resource group name where the App Service Plan will be created"
  type        = string
}

variable "sku_name" {
  default = "P1v2"
  type = string
  description = "sku name"
}

variable "os_type" {
    default = "Windows"
    type = string
    description = "type of OS"
}