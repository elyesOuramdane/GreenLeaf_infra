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

