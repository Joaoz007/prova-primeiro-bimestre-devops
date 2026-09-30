# ── Rede ──────────────────────────────────────────────────────────────────────
variable "vpc_cidr" {
  type        = string
  description = "CIDR block da VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR da subnet pública"
  default     = "10.0.1.0/24"
}

variable "private_subnet_a_cidr" {
  type        = string
  description = "CIDR da subnet privada A"
  default     = "10.0.2.0/24"
}

variable "private_subnet_b_cidr" {
  type        = string
  description = "CIDR da subnet privada B"
  default     = "10.0.3.0/24"
}

variable "az_public" {
  type        = string
  description = "AZ da subnet pública"
  default     = "us-east-1a"
}

variable "az_private_a" {
  type        = string
  description = "AZ da subnet privada A"
  default     = "us-east-1a"
}

variable "az_private_b" {
  type        = string
  description = "AZ da subnet privada B"
  default     = "us-east-1b"
}

# ── EC2 ───────────────────────────────────────────────────────────────────────
variable "ami_id" {
  type        = string
  description = "ID da AMI para a instância EC2 (ex: Amazon Linux 2023 em us-east-1)"
}

variable "instance_type" {
  type        = string
  description = "Tipo da instância EC2"
  default     = "t2.micro"
}

# ── RDS ───────────────────────────────────────────────────────────────────────
variable "db_name" {
  type        = string
  description = "Nome do banco de dados PostgreSQL"
  default     = "technova"
}

variable "db_username" {
  type        = string
  description = "Usuário do banco de dados PostgreSQL"
  default     = "technova_user"
}

variable "db_password" {
  type        = string
  description = "Senha do banco de dados PostgreSQL"
  sensitive   = true
}

variable "db_instance_class" {
  type        = string
  description = "Tipo da instância RDS"
  default     = "db.t3.micro"
}
