
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
      
    }
  }
}

provider "azurerm" {
  features {}

  #subscription_id   = "084971f5-dda5-4b57-9062-2e9289a1962e"
  #client_id         = "e12473c6-8f01-4c94-8a8a-72a604531087"
  #client_secret     = "keL8Q~IAaDi61-wppB3djFVvZ1.55Eqd6iNcwdlB"
  #tenant_id         = "db8e2f82-8a37-4c09-b7de-ed06547b5a20"
}

terraform {
  backend "azurerm" {
    storage_account_name = "staccttfstate01"
    container_name       = "tfstate1"
    key                  = "prod.terraform.tfstate"
    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
   access_key = "DfemT/bwBsfUQ7bVWEWQgX/0kEz6SKP3S4ze38bn6d9YcY/l8n1xYOAZ58+j/S6iEKqWXFKslFHn+AStXHeupQ=="
  }
}


resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}_resources_${var.instance_count}"
  location = var.location
}



resource "azurerm_storage_account" "example" {
  name                = "${var.prefix}storageacct${var.instance_count}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  account_tier                    = "Standard"
  account_kind                    = "StorageV2"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  access_tier                     = "Hot"
  allow_nested_items_to_be_public = true
}

resource "azurerm_storage_container" "example" {
  name                  = "${var.prefix}storagecontainer${var.instance_count}"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "blob"
}

