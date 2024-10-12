variable "resource_group_name" {
  description = "The name of the resource group where the HDInsight cluster will be created"
  default     = "hdinsight-kafka-rg"
}

variable "location" {
  description = "The Azure region where the resources will be created"
  default     = "West Europe"
}

variable "cluster_name" {
  description = "The name of the HDInsight Kafka cluster"
  default     = "kafka-hh"
}

variable "cluster_version" {
  description = "The version of the HDInsight cluster"
  default     = "4.0"
}

variable "kafka_worker_node_size" {
  description = "The size of the Kafka worker nodes"
  default     = "ExtraSmall"
}

variable "kafka_worker_node_count" {
  description = "The number of worker nodes in the Kafka cluster"
  default     = 3
}

variable "storage_account_name" {
  description = "The name of the Azure Storage account for the Kafka cluster"
  default     = "kafkastoreacc"
}

variable "storage_container_name" {
  description = "The name of the Azure Blob storage container for Kafka logs"
  default     = "kafkastorage"
}

variable "ssh_user" {
  description = "The SSH username for accessing the HDInsight cluster"
  default     = "hdinsightuser"
}

variable "ssh_public_key" {
  description = "The SSH public key for accessing the HDInsight cluster"
  default     = ""
}
