variable "vpc_cidr" {
  type        = string
  description = "CIDR block da VPC"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR da subnet pública"
}

variable "private_subnet_a_cidr" {
  type        = string
  description = "CIDR da subnet privada A"
}

variable "private_subnet_b_cidr" {
  type        = string
  description = "CIDR da subnet privada B"
}

variable "az_public" {
  type        = string
  description = "AZ da subnet pública"
}

variable "az_private_a" {
  type        = string
  description = "AZ da subnet privada A"
}

variable "az_private_b" {
  type        = string
  description = "AZ da subnet privada B"
}
