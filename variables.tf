variable "rg_name" {
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

variable "wwa1" {
  default = "ase-ben-wus-tst-002"
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

variable "vn-address" {
  type = string
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

variable "target_enviromnet" {
  default = "Dev"
}

variable "env_list" {
  type = list(string)
  default = ["DEV", "PREPROD", "PROD"]
}

variable "compute_storage_tags" {
  type = list
  default = ["web"]
}

variable "env_map" {
  type = map(string)
  default = {
    "DEV" = "dev",
    "PREPROD" = "preprod",
    "PROD" = "prod"
  }
}

variable "env_machine_type" {
  type = map(string)
  default = {
    "Dev" = "f1-micro",
    "Preprod" = "f1-micro",
    "Prod" = "f1-micro"
  }
}

variable "env_instance_settings" {
  type = map(object({machine_type =  string, tags = list(string)}))
  default = {
    "DEV" = {
      machine_type = "f1-micro"
      tags = ["dev"]
    },
    "PREPROD" = {
      machine_type = "f1-micro"
      tags = ["preprod"]
    },
    "PROD" = {
      machine_type = "f1-micro"
      tags = ["prod"]
    }
  }
}

variable "administrator_login" {
  type = string
  default = "admin"
  sensitive = true
}

variable "admin_password" {
  type = string
  sensitive = true
}