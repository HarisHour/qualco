output "hdinsight_kafka_cluster_url" {
  description = "The URL of the HDInsight Kafka cluster"
  value       = azurerm_hdinsight_kafka_cluster.kafka_cluster.https_endpoint
}

output "ssh_user" {
  description = "The SSH username for accessing the Kafka cluster"
  value       = var.ssh_user
}

output "ssh_public_key" {
  description = "The SSH public key to use when logging into the Kafka cluster"
  value       = var.ssh_public_key
}

