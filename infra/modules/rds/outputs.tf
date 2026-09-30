output "rds_endpoint" {
  description = "Endpoint de conexao do RDS PostgreSQL"
  value       = aws_db_instance.this.endpoint
}

output "rds_port" {
  description = "Porta do RDS PostgreSQL"
  value       = aws_db_instance.this.port
}
