data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

module "network" {
  source             = "../../modules/network"
  environment        = "dev"
  vpc_cidr           = "10.0.0.0/16"
  single_nat_gateway = true
  availability_zones = ["eu-north-1a", "eu-north-1b"]
  region             = "eu-north-1"
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

  instance_type        = "t3.medium"
  min_size             = 1
  desired_capacity     = 1
  max_size             = 2
  alb_target_group_arn = module.loadbalancer.target_group_arn
  security_group_ids   = [module.security.app_sg_id]
  efs_id               = module.efs.id
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

  db_username = var.db_username
  db_password = var.db_password
  db_name     = "greenleaf_dev"

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

module "opensearch" {
  source             = "../../modules/opensearch"
  identifier         = "greenleaf-dev"
  environment        = "dev"
  region             = data.aws_region.current.name
  account_id         = data.aws_caller_identity.current.account_id
  subnet_ids         = module.network.subnet_data_ids # Use Data subnets for persistence
  security_group_ids = [module.security.opensearch_sg_id]
  instance_type      = "t3.small.search"
}

resource "local_file" "ansible_vars" {
  filename = "../../../ansible/inventory/group_vars/all.yml"
  content  = <<EOT
magento_db_host: "${module.database.endpoint}"
magento_db_user: "${var.db_username}"
magento_db_password: "${var.db_password}"
magento_db_name: "greenleaf_dev"

magento_redis_host: "${module.redis.hostname}"
magento_opensearch_host: "https://${module.opensearch.endpoint}"

magento_base_url: "http://${module.loadbalancer.alb_dns_name}/"

magento_admin_firstname: "${var.magento_admin_firstname}"
magento_admin_lastname: "${var.magento_admin_lastname}"
magento_admin_email: "${var.magento_admin_email}"
magento_admin_user: "${var.magento_admin_user}"
magento_admin_password: "${var.magento_admin_password}"

magento_language: "en_US"
magento_currency: "USD"
magento_timezone: "UTC"
EOT
}
