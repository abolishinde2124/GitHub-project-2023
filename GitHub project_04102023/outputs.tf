output "VPC" {
  value = module.vpc.vpc_id
}

output "dbEndpoing" {
  # sensitive = true
  value = module.rds.db_instance_address
}

output "rds" {
  value = module.rds.db_instance_address
}