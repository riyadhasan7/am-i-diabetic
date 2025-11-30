variable "resource_group_name" {
  description = "The name of the resource group in which to create resources."
  type        = string
}

variable "vnet" {
  description = "The virtual network object."
  type        = any
}


variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
}