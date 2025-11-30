variable "resource_name_prefix" {
  description = "A prefix for naming resources."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create resources."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = string
}

variable "database_subnet_ids" {
  description = "The IDs for the database subnet."
  type        = list(string)
}

variable "database_private_dns_zone_id" {
  description = "The ID of the private DNS zone for the database."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
}