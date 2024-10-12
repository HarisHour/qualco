resource "azurerm_virtual_network" "kafka_vnet" {
  name                = "kafka-vnet"
  resource_group_name = azurerm_resource_group.hdinsight_rg.name
  location            = azurerm_resource_group.hdinsight_rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "kafka_subnet" {
  name                 = "kafka-subnet"
  resource_group_name  = azurerm_resource_group.hdinsight_rg.name
  virtual_network_name = azurerm_virtual_network.kafka_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_hdinsight_kafka_cluster" "kafka_cluster" {
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.hdinsight_rg.name
  location            = azurerm_resource_group.hdinsight_rg.location
  cluster_version     = var.cluster_version
  tier                = "Standard"

  component_version {
    kafka = "2.1"
  }

  gateway {
    username   = var.ssh_user
    password   = random_password.password.result
  }

  storage_account {
    storage_container_id = azurerm_storage_container.kafka_storage_container.id
    storage_account_key  = azurerm_storage_account.kafka_storage_account.primary_access_key
    is_default = true
  }

  roles {
    head_node {
      vm_size = "ExtraSmall"
      username = var.ssh_user
      ssh_keys = [var.ssh_public_key]
    }

    worker_node {
      vm_size = var.kafka_worker_node_size
      username = var.ssh_user
      ssh_keys = [var.ssh_public_key]
      target_instance_count = var.kafka_worker_node_count
      number_of_disks_per_node = 1
    }

    zookeeper_node {
      vm_size = "ExtraSmall"
      username = var.ssh_user
      ssh_keys = [var.ssh_public_key]
    }
  }
}

