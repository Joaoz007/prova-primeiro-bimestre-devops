output "ec2_public_ip" {
  description = "IP público da instância EC2"
  value       = module.ec2.ec2_public_ip
}

output "rds_endpoint" {
  description = "Endpoint de conexão do RDS PostgreSQL"
  value       = module.rds.rds_endpoint
}
