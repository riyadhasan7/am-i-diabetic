#output database DB_Password
output "db_password" {
  description = "The password for the database."
  value       = random_password.mysql_password.result
  sensitive   = true
}