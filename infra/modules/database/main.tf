resource "random_password" "mysql_password" {
  length           = 16
  special          = true
  override_special = "_%@"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  
}

# Create a MySQL Flexible Server with Private Endpoint and a Web App
resource "azurerm_mysql_flexible_server" "server" {
  name                   = "${var.resource_name_prefix}-mysql-server"
  resource_group_name    = var.resource_group_name
  location               = var.location
  delegated_subnet_id    = var.database_subnet_ids[0]
  private_dns_zone_id    = var.database_private_dns_zone_id
  administrator_login    = "mysqladmin"
  administrator_password = random_password.mysql_password.result
  version                = "8.0"
  sku_name               = "GP_Standard_D2ds_v4"
  storage_mb             = 32768
  backup_retention_days  = 7
  public_network_access_enabled = false
  auto_grow_enabled      = true
  tags                   = var.tags

  high_availability {
    mode = "ZoneRedundant"
  }
}


resource "azurerm_mysql_flexible_database" "database" {
  name                = "diabetes_db"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_flexible_server_configuration" "wait_timeout" {
  name                = "wait_timeout"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.server.name
  value               = "28800"
}

