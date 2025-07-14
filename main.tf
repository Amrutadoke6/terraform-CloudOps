module "vpc" {
  source  = "./modules/vpc"
  project = var.project

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "security" {
  source  = "./modules/security"
  project = var.project
  vpc_id  = module.vpc.vpc_id
}

module "compute" {
  source                = "./modules/compute"
  project               = var.project
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  sg_id                 = module.security.ec2_sg_id
  instance_profile_name = module.security.ec2_instance_profile_name
}

module "rds" {
  source          = "./modules/rds"
  project         = var.project
  private_subnets = module.vpc.private_subnets
  sg_id           = module.security.rds_sg_id
  db_user         = var.db_user
  db_pass         = var.db_pass
}

module "monitoring" {
  source   = "./modules/monitoring"
  project  = var.project
  asg_name = module.compute.asg_name
}

