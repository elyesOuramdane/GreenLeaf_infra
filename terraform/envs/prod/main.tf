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

