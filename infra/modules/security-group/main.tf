# ── Security Group da EC2 ─────────────────────────────────────────────────────
resource "aws_security_group" "sg_ec2" {
  name        = "technova-sg-ec2"
  description = "Security Group da instancia EC2 da API TechNova"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "API HTTP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Saida irrestrita"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "technova-sg-ec2"
  }
}

# ── Security Group do RDS ─────────────────────────────────────────────────────
resource "aws_security_group" "sg_rds" {
  name        = "technova-sg-rds"
  description = "Security Group do RDS PostgreSQL TechNova"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL somente da EC2"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_ec2.id]
  }

  egress {
    description = "Saida irrestrita"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "technova-sg-rds"
  }
}
