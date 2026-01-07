module "network" {
  source             = "../../modules/network"
  environment        = "prod"
  vpc_cidr           = "10.1.0.0/16"
  single_nat_gateway = false
}

# module "compute" {
#   source = "../../modules/compute"
#   # vars here
# }


module "database" {
  source = "../../modules/database"

  identifier        = "greenleaf-prod"
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.private_subnets
  vpc_cidr          = "10.1.0.0/16" 
  
  db_username       = var.db_username
  db_password       = var.db_password
  db_name           = "greenleaf_prod"
  
  instance_class    = "db.t3.medium"
  allocated_storage = 20
  multi_az          = true
}
