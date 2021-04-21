data "aws_region" "current" {}

data "aws_ami" "ansible" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  active_active  = var.node_count >= 2
  ami_id         = local.default_ami_id ? data.aws_ami.ubuntu.id : var.ami_id
  default_ami_id = var.ami_id == ""
  fqdn           = "${var.tfe_subdomain}.${var.domain_name}"
}

module "networking" {
  source = "./modules/networking"

  deploy_vpc                   = var.deploy_vpc
  friendly_name_prefix         = var.friendly_name_prefix
  network_cidr                 = var.network_cidr
  network_private_subnet_cidrs = var.network_private_subnet_cidrs
  network_public_subnet_cidrs  = var.network_public_subnet_cidrs

  common_tags = var.common_tags
}

locals {
  bastion_host_subnet          = var.deploy_vpc ? module.networking.bastion_host_subnet : var.bastion_host_subnet
  network_id                   = var.deploy_vpc ? module.networking.network_id : var.network_id
  network_private_subnets      = var.deploy_vpc ? module.networking.network_private_subnets : var.network_private_subnets
  network_public_subnets       = var.deploy_vpc ? module.networking.network_public_subnets : var.network_public_subnets
  network_private_subnet_cidrs = var.deploy_vpc ? module.networking.network_private_subnet_cidrs : var.network_private_subnet_cidrs
}

module "database" {
  source = "./modules/database"

  db_size                      = var.db_size
  engine_version               = var.postgres_engine_version
  friendly_name_prefix         = var.friendly_name_prefix
  network_id                   = local.network_id
  network_private_subnet_cidrs = var.network_private_subnet_cidrs
  network_subnets_private      = local.network_private_subnets
  tfe_instance_sg              = module.vm.tfe_instance_sg

  common_tags = var.common_tags
}


module "user_data" {
  source = "./modules/user_data"

  active_active                 = local.active_active
  aws_region                    = data.aws_region.current.name
  fqdn                          = local.fqdn
  pg_dbname                     = module.database.db_name
  pg_password                   = module.database.db_password
  pg_netloc                     = module.database.db_endpoint
  pg_user                       = module.database.db_username
  proxy_cert_bundle_name        = var.proxy_cert_bundle_name
  proxy_ip                      = var.proxy_ip
  no_proxy                      = var.no_proxy
}

module "load_balancer" {
  count  = var.load_balancing_scheme != "PRIVATE_TCP" ? 1 : 0
  source = "./modules/application_load_balancer"

  active_active                  = local.active_active
  admin_dashboard_ingress_ranges = var.admin_dashboard_ingress_ranges
  certificate_arn                = var.acm_certificate_arn
  domain_name                    = var.domain_name
  friendly_name_prefix           = var.friendly_name_prefix
  fqdn                           = local.fqdn
  load_balancing_scheme          = var.load_balancing_scheme
  network_id                     = local.network_id
  network_public_subnets         = local.network_public_subnets
  network_private_subnets        = local.network_private_subnets
  ssl_policy                     = var.ssl_policy

  common_tags = var.common_tags
}

module "private_tcp_load_balancer" {
  count  = var.load_balancing_scheme == "PRIVATE_TCP" ? 1 : 0
  source = "./modules/network_load_balancer"

  active_active           = local.active_active
  certificate_arn         = var.acm_certificate_arn
  domain_name             = var.domain_name
  friendly_name_prefix    = var.friendly_name_prefix
  fqdn                    = local.fqdn
  network_id              = local.network_id
  network_private_subnets = local.network_private_subnets
  ssl_policy              = var.ssl_policy

  common_tags = var.common_tags
}

module "vm" {
  source = "./modules/vm"

  active_active                       = local.active_active
  aws_iam_instance_profile            = module.service_accounts.aws_iam_instance_profile
  ami_id                              = local.ami_id
  aws_lb                              = var.load_balancing_scheme == "PRIVATE_TCP" ? null : module.load_balancer[0].aws_lb_security_group
  aws_lb_target_group_tfe_tg_443_arn  = var.load_balancing_scheme == "PRIVATE_TCP" ? module.private_tcp_load_balancer[0].aws_lb_target_group_tfe_tg_443_arn : module.load_balancer[0].aws_lb_target_group_tfe_tg_443_arn
  aws_lb_target_group_tfe_tg_8800_arn = var.load_balancing_scheme == "PRIVATE_TCP" ? module.private_tcp_load_balancer[0].aws_lb_target_group_tfe_tg_8800_arn : module.load_balancer[0].aws_lb_target_group_tfe_tg_8800_arn
  bastion_key                         = local.bastion_key_public
  bastion_sg                          = local.bastion_sg
  default_ami_id                      = local.default_ami_id
  friendly_name_prefix                = var.friendly_name_prefix
  instance_type                       = var.instance_type
  network_id                          = local.network_id
  network_subnets_private             = local.network_private_subnets
  network_private_subnet_cidrs        = local.network_private_subnet_cidrs
  node_count                          = var.node_count
  userdata_script                     = module.user_data.tfe_userdata_base64_encoded
}
