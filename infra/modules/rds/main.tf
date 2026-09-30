# ── DB Subnet Group ───────────────────────────────────────────────────────────
resource "aws_db_subnet_group" "this" {
  name       = "technova-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "technova-db-subnet-group"
  }
}

# ── Instancia RDS PostgreSQL ──────────────────────────────────────────────────
resource "aws_db_instance" "this" {
  identifier     = "technova-rds"
  engine         = "postgres"
  engine_version = "15"
  instance_class = var.instance_class
  db_name        = var.db_name
  username       = var.db_username
  password       = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.security_group_id]

  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  multi_az            = false
  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "technova-rds"
  }
}
