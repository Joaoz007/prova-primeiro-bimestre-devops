variable "db_name" {
  type        = string
  description = "Nome do banco de dados PostgreSQL"
}

variable "db_username" {
  type        = string
  description = "Usuario do banco de dados PostgreSQL"
}

variable "db_password" {
  type        = string
  description = "Senha do banco de dados PostgreSQL"
  sensitive   = true
}

variable "instance_class" {
  type        = string
  description = "Tipo da instancia RDS"
  default     = "db.t3.micro"
}

variable "subnet_ids" {
  type        = list(string)
  description = "IDs das duas subnets privadas para o DB subnet group"
}

variable "security_group_id" {
  type        = string
  description = "ID do Security Group a ser associado ao RDS"
}
