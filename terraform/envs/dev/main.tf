module "network" {
  source             = "../../modules/network"
  environment        = "dev"
  vpc_cidr           = "10.0.0.0/16"
  single_nat_gateway = true
}

module "compute" {
  source            = "../../modules/compute"
  environment       = "dev"
  vpc_id            = module.network.vpc_id
  private_subnet_ids = module.network.subnet_private_ids

  instance_type     = "t3.small"
  min_size          = 1
  desired_capacity  = 1
  max_size          = 2
}


module "security" {
  app_sg_id = module.compute.app_sg_id
  source   = "../../modules/security"
  vpc_id   = module.network.vpc_id
  vpc_cidr = "10.0.0.0/16"
}

module "database" {
  source = "../../modules/database"

  identifier            = "greenleaf-dev"
  db_subnet_group_name  = module.network.db_subnet_group_name
  db_security_group_ids = [module.security.rds_sg_id]
  
  db_username       = var.db_username
  db_password       = var.db_password
  db_name           = "greenleaf_dev"
  
  instance_class    = "db.t3.micro" # Using micro for dev to save cost
  allocated_storage = 20
  multi_az          = false # No Multi-AZ for dev to save cost
}
