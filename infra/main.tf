# ── Módulo VPC ────────────────────────────────────────────────────────────────
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
  az_public             = var.az_public
  az_private_a          = var.az_private_a
  az_private_b          = var.az_private_b
}

# ── Módulo Security Group ─────────────────────────────────────────────────────
module "security_group" {
  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id
}

# ── Módulo EC2 ────────────────────────────────────────────────────────────────
module "ec2" {
  source = "./modules/ec2"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_group.sg_ec2_id
  key_name          = var.key_name
}

# ── Módulo RDS ────────────────────────────────────────────────────────────────
module "rds" {
  source = "./modules/rds"

  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  instance_class    = var.db_instance_class
  subnet_ids        = [module.vpc.private_subnet_a_id, module.vpc.private_subnet_b_id]
  security_group_id = module.security_group.sg_rds_id
}
