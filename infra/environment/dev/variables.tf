variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)"
  type        = string
}

variable "resource_name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "resource_group_name" {
  description = "resource group name"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

# Network variables
variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
}

# public subnets(frontend)
variable "public_subnets_prefixes" {
  description = "Address prefixes for public subnets (frontend)"
  type        = list(string)
}

# private subnets(backend)
variable "private_subnets_prefixes" {
  description = "Address prefixes for private subnets (backend)"
  type        = list(string)
}

# database subnets
variable "database_subnets_prefixes" {
  description = "Address prefixes for database subnets"
  type        = list(string)
}

# Application Gateway subnet
variable "appgw_subnet_prefix" {
  description = "Address prefix for Application Gateway subnet"
  type        = string
}

# Bastion subnet
variable "bastion_subnet_prefix" {
  description = "Address prefix for Bastion subnet"
  type        = string
}

# Compute variables
variable "frontend_instance_count" {
  description = "Number of frontend instances"
  type        = number
}

variable "backend_instance_count" {
  description = "Number of frontend instances"
  type        = number
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}