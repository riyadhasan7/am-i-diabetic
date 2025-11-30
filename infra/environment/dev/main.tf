
# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}-${var.environment}"
  location = var.location
  tags     = var.tags
}

# Networking Module
module "networking" {
  source                    = "../../modules/networking"
  resource_group_name       = azurerm_resource_group.main.name
  location                  = var.location
  resource_name_prefix      = var.resource_name_prefix
  vnet_address_space        = var.vnet_address_space
  public_subnets_prefixes   = var.public_subnets_prefixes
  private_subnets_prefixes  = var.private_subnets_prefixes
  database_subnets_prefixes = var.database_subnets_prefixes
  bastion_subnet_prefix     = var.bastion_subnet_prefix
  appgw_subnet_prefix       = var.appgw_subnet_prefix
  tags                      = var.tags
}

# Frontend Compute Module
module "frontend_compute" {
  source                  = "../../modules/compute/frontend"
  resource_group_name     = azurerm_resource_group.main.name
  location                = var.location
  resource_name_prefix    = var.resource_name_prefix
  appgw_subnet_id         = module.networking.appgw_subnet_id
  public_subnets_prefixes = var.public_subnets_prefixes
  subnet_id               = module.networking.public_subnet_ids[0]
  frontend_instance_count = var.frontend_instance_count
  tags                    = var.tags
}



# Backend Compute Module
module "backend_compute" {
  source                 = "../../modules/compute/backend"
  resource_group_name    = azurerm_resource_group.main.name
  location               = var.location
  resource_name_prefix   = var.resource_name_prefix
  subnet_id              = module.networking.private_subnet_ids[0]
  backend_instance_count = var.backend_instance_count
  environment            = var.environment
  tags                   = var.tags

}


# Get current Azure client config for tenant_id and object_id
data "azurerm_client_config" "current" {}

# Key Vault Module
module "key_vault" {
  source                           = "../../modules/key-vault"
  resource_group_name              = azurerm_resource_group.main.name
  location                         = var.location
  resource_name_prefix             = var.resource_name_prefix
  tenant_id                        = data.azurerm_client_config.current.tenant_id
  object_id                        = data.azurerm_client_config.current.object_id # your user/service principal object ID
  frontend_identity_principal_id   = module.frontend_compute.identity_principal_id
  backend_identity_principal_id    = module.backend_compute.identity_principal_id
  frontend_ssh_key                 = module.frontend_compute.ssh_private_key
  backend_ssh_key                  = module.backend_compute.ssh_private_key
  tags                             = var.tags
}

resource "azurerm_key_vault_secret" "mysql_host" {
  name         = "DB_Host"
  value        = module.database.db_host
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.database, module.key_vault]
}

resource "azurerm_key_vault_secret" "mysql_password" {
  name         = "DB_Password"
  value        = module.database.db_password
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.database, module.key_vault]
}

resource "azurerm_key_vault_secret" "mysql_database_name" {
  name         = "DB_Name"
  value        = module.database.db_name
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.database, module.key_vault]
}

resource "azurerm_key_vault_secret" "mysql_username" {
  name         = "DB_Username"
  value        = module.database.db_username
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.database, module.key_vault]
}

resource "azurerm_key_vault_secret" "mysql_port" {
  name         = "DB_Port"
  value        = module.database.db_port
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.database, module.key_vault]
}

resource "azurerm_key_vault_secret" "mysql_ssl_mode" {
  name         = "DB_SSL_Mode"
  value        = module.database.db_ssl_mode
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.database, module.key_vault]
}


# Database module
module "database" {
  source                 = "../../modules/database"
  resource_group_name    = azurerm_resource_group.main.name
  location               = var.location
  resource_name_prefix   = var.resource_name_prefix
  vnet_address_space     = var.vnet_address_space
  database_subnet_ids    = module.networking.database_subnet_ids
  database_private_dns_zone_id = module.dns.private_dns_zone_id
  tags                   = var.tags
}


# DNS Module
module "dns" {
  source                 = "../../modules/dns"
  resource_group_name    = azurerm_resource_group.main.name
  vnet_id                = module.networking.vnet_id
  tags                   = var.tags
}








# az ad sp create-for-rbac -n az-demo --role="Contributor" --scopes="/subscriptions/"add subscription id here""


# export ARM_CLIENT_ID="2dcdddaa-3a32-4141-b206-2d9b243e9894"
# export ARM_CLIENT_SECRET="add your secret here"
# export ARM_SUBSCRIPTION_ID="207b19a0-884b-4b51-bd04-f1512c550995"
# export ARM_TENANT_ID="81046c6e-26f2-42a3-96ed-0d28a98c1cdc"
