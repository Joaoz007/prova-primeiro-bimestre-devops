variable "ami_id" {
  type        = string
  description = "ID da AMI para a instancia EC2"
}

variable "instance_type" {
  type        = string
  description = "Tipo da instancia EC2"
  default     = "t2.micro"
}

variable "subnet_id" {
  type        = string
  description = "ID da subnet publica onde a EC2 sera criada"
}

variable "security_group_id" {
  type        = string
  description = "ID do Security Group a ser associado a EC2"
}
