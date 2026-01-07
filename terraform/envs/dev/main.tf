module "network" {
  source             = "../../modules/network"
  environment        = "dev"
  vpc_cidr           = "10.0.0.0/16"
  single_nat_gateway = true
}

# module "compute" {
#   source = "../../modules/compute"
#   # vars here
# }


module "security" {
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
