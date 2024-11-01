terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.49"
    }
  }
  cloud {
    organization = "cloudruler"
    workspaces {
      name = "connectivity"
    }
  }
  required_version = ">= 0.14.7"
}