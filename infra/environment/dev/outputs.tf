
# Output the VNet name
output "networking-vnet_name" {
  value = module.networking.vnet_name
}


# Output the Application-gateway-public-ip
output "Application-gateway-public-ip" {
  value = module.frontend_compute.appgw_public_ip
}






