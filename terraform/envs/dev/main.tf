module "network" {
  source             = "../../modules/network"
  environment        = "dev"
  vpc_cidr           = "10.0.0.0/16"
  single_nat_gateway = true
}

module "loadbalancer" {
  source             = "../../modules/loadbalancer"
  environment        = "dev"
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.subnet_public_ids
  security_group_ids = [module.security.alb_sg_id]
}

module "compute" {
  source             = "../../modules/compute"
  environment        = "dev"
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.subnet_private_ids

  instance_type        = "t3.small"
  min_size             = 1
  desired_capacity     = 1
  max_size             = 2
  alb_target_group_arn = module.loadbalancer.target_group_arn
  security_group_ids   = [module.security.app_sg_id]
}


module "security" {
  source     = "../../modules/security"
  identifier = "greenleaf-dev"
  vpc_id     = module.network.vpc_id
  vpc_cidr   = "10.0.0.0/16"
}

module "database" {
  source = "../../modules/database"

  identifier            = "greenleaf-dev"
  db_subnet_group_name  = module.network.db_subnet_group_name
  db_security_group_ids = [module.security.rds_sg_id]
  
  db_username       = var.db_username
  db_password       = var.db_password
  db_name           = "greenleaf_dev"
  
  instance_class    = "db.t3.small" # Using small for dev to save cost
  allocated_storage = 20
  multi_az          = false # No Multi-AZ for dev to save cost
}

module "efs" {
  source             = "../../modules/efs"
  identifier         = "greenleaf-dev"
  subnet_ids         = module.network.subnet_private_ids
  security_group_ids = [module.security.efs_sg_id]
}

module "redis" {
  source                        = "../../modules/redis"
  identifier                    = "greenleaf-dev"
  elasticache_subnet_group_name = module.network.elasticache_subnet_group_name
  security_group_ids            = [module.security.redis_sg_id]
  node_type                     = "cache.t3.micro"
  multi_az                      = false
}
