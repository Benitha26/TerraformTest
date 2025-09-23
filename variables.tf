variable "rg" {
  type = string
  default = "rg-ben-tst-001"
  description = "value for the resource group"
}

variable "location" {
  type = string
  default = "East US"
}

variable "asp" {
  default = "asp-ben-wus-tst"
  type = string
}

variable "wwa" {
  default = "ase-ben-wus-tst-001"
  type = string
}

variable "sqlserver" {
  default = "dbs-ben-wus-tst"
}

variable "sqldb" {
  default = "db-ben-wus-tst"
}

variable "vnet" {
  default = "vn-ben-wus-tst-001"
}

variable "snet" {
  default = "sn-ben-wus-tst-001"
}

variable "nic" {
  default = "nic-01-vmben-tst-001"
}

variable "vm" {
  default = "vm-ben-tst-001"
}

variable "nsg" {
  default = "nsg-bentst-001"
}