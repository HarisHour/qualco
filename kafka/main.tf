resource "azurerm_resource_group" "hdinsight_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "kafka_storage_account" {
  name                     = var.storage_account_name
  resource_group_name       = azurerm_resource_group.hdinsight_rg.name
  location                 = azurerm_resource_group.hdinsight_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "kafka_storage_container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.kafka_storage_account.name
  container_access_type = "private"
}

resource "random_password" "password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}


