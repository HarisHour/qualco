resource "azurerm_mssql_server" "sql_server" {
  name                         = "sqlserver-demo"
  resource_group_name          = azurerm_resource_group.aks_rg.name
  location                     = azurerm_resource_group.aks_rg.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
}

resource "azurerm_mssql_database" "sql_db" {
  name                = "springbootdb"
  server_id           = azurerm_mssql_server.sql_server.id
  sku_name            = "S0"
}

output "sql_db_connection_string" {
  description = "Connection string for MSSQL database"
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}
