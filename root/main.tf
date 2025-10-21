module "network" {
  source              = "../modules/network"
  region              = var.region
  module_prefix       = var.project_name
  vpc_cidr            = var.vpc_cidr
  pub_sub_a_cidr      = var.pub_sub_a_cidr
  pub_sub_b_cidr      = var.pub_sub_b_cidr
  pri_sub_web_a_cidr  = var.pri_sub_web_a_cidr
  pri_sub_web_b_cidr  = var.pri_sub_web_b_cidr
  pri_sub_data_a_cidr = var.pri_sub_data_a_cidr
  pri_sub_data_b_cidr = var.pri_sub_data_b_cidr
}

module "nat" {
  source        = "../modules/nat"
  module_prefix = var.project_name
  igw_id        = module.network.igw_id
  vpc_id        = module.network.vpc_id
  pub_sub_a_id  = module.network.pub_sub_a_id
  pub_sub_b_id  = module.network.pub_sub_b_id

  pri_sub_web_a_id  = module.network.pri_sub_web_a_id
  pri_sub_web_b_id  = module.network.pri_sub_web_b_id
  pri_sub_data_a_id = module.network.pri_sub_data_a_id
  pri_sub_data_b_id = module.network.pri_sub_data_b_id
}

module "security-group" {
  source        = "../modules/security-group"
  module_prefix = var.project_name
  vpc_id        = module.network.vpc_id
}

module "alb" {
  source        = "../modules/alb"
  module_prefix = var.project_name
  alb_sg_id     = module.security-group.alb_sg_id
  pub_sub_a_id  = module.network.pub_sub_a_id
  pub_sub_b_id  = module.network.pub_sub_b_id
  vpc_id        = module.network.vpc_id
}

module "asg" {
  source           = "../modules/asg"
  module_prefix    = var.project_name
  web_sg_id        = module.security-group.web_sg_id
  pri_sub_web_a_id = module.network.pri_sub_web_a_id
  pri_sub_web_b_id = module.network.pri_sub_web_b_id
  tg_arn           = module.alb.tg_arn
  user_data        = filebase64("${path.module}/user-data-scripts/simple-apache.sh")
}

module "rds" {
  source            = "../modules/rds"
  module_prefix     = var.project_name
  db_sg_id          = module.security-group.db_sg_id
  pri_sub_data_a_id = module.network.pri_sub_data_a_id
  pri_sub_data_b_id = module.network.pri_sub_data_b_id
  db_username       = var.db_username
  db_password       = var.db_password
}

module "route53" {
  source             = "../modules/r53"
  alb_dns_name       = module.alb.alb_dns_name
  alb_hosted_zone_id = module.alb.alb_hosted_zone_id
  sub_domain         = var.sub_domain
}
