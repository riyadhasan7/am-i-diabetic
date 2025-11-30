resource_group_name  = "diabetic-app-rg"
location             = "UK South"
resource_name_prefix = "diabetic-app"
environment          = "dev"


# Networking configurations
vnet_address_space        = "10.0.0.0/16"
public_subnets_prefixes   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_prefixes  = ["10.0.3.0/24", "10.0.4.0/24"]
database_subnets_prefixes = ["10.0.5.0/24", "10.0.6.0/24"]
bastion_subnet_prefix     = "10.0.7.0/24"
appgw_subnet_prefix       = "10.0.8.0/24"

# Compute configurations
frontend_instance_count = 2
backend_instance_count  = 2


# Tags
tags = {
  Environment = "Development"
  Project     = "DiabeticApp"
}