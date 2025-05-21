terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>4.7"   #  Specify the latest version of the provider
    }
  }

}
provider "azurerm" {
  features {}
}
