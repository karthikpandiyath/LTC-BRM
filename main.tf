terraform {
  required_providers {
    mumbai = {
      source  = "hashicorp/aws"
      version = "3.66"
    }
  }
}

module "vpc" {
  source = "./modules/VPC"
  private_cidr_block = var.private_cidr_block
  private_db_cidr_block = var.private_db_cidr_block
  private_db_name = var.private_db_name
  private_db_subnet_count = var.private_db_subnet_count
  private_db_subnet_name = var.private_db_subnet_name
  private_subnet_count = var.private_subnet_count
  private_subnet_name = var.private_subnet_name
  public_cidr_block = var.public_cidr_block
  public_subnet_count = var.public_subnet_count
  public_subnet_name = var.public_subnet_name
  igw_name = var.igw_name
  vpc_cidr = var.vpc_cidr
  availability_zones = var.availability_zone
}

module "ec2_instances_prod_pub_az1" {
  source              = "./modules/ec2"
  instance_count      = var.instance_count[0]
  ami_id              = var.ami_id[0]
  instance_type       = var.instance_type
  subnet_id           = module.vpc.public_subnet1_id
  availability_zone   = var.area_zone[0]   
}
# main.tf

module "ec2_instances_prod_pub_az2" {
  source              = "./modules/ec2"
  instance_count      = var.instance_count[1]
  ami_id              = var.ami_id[1]
  instance_type       = var.instance_type
  subnet_id           = module.vpc.public_subnet2_id
  availability_zone   = var.area_zone[1]   
}

module "ec2_instances_prod_app_az1" {
  source              = "./modules/ec2"
  instance_count      = var.instance_count[2]
  ami_id              = var.ami_id[2]
  instance_type       = var.instance_type
  subnet_id           = module.vpc.private_subnet1_id
  availability_zone   = var.area_zone[0]   
}

module "RDS" {
  source = "./modules/rds"
  db_instance_uae = var.db_instance_uae
  environment = var.environment
  avaliability_zone = var.availability_zone
}

resource "aws_ebs_volume" "example" {
  size              = 40
  subnet_id           = module.vpc.public_subnet1_id
  availability_zone   = var.area_zone[0] 
  tags = {
    Name = "brm-prod-ltc-pvdata"
  }
}

module "loadbalancer" {
  source = "./modules/Loadbalancer"
  subnets    = [module.vpc.private_subnet[0],module.vpc.private_subnet[1]]
  target_id1 = module.server.instance_id[0]
  target_id2 = module.server.instance_id[1]
  vpc_id     = module.vpc.vpc_id
  certificate_arn = module.certificate.certificate_arn
  lb1_name = var.loadbalancer1_name
}
module "inspector" {
  source = "../.."

  create_iam_role = var.create_iam_role
  enabled_rules   = var.enabled_rules
  context = module.this.context
}
#trusted advsior
resource "random_id" "new" {
  byte_length = 4
}


locals {
  name_prefix              = "${lower(random_id.new.id)}-"
  tags                     = {}
  lambda_alias_name        = "LIVE"
  admin_account_role_name  = "${local.name_prefix}AdminAccountRole"  # include path prefix without starting /
  member_account_role_name = "${local.name_prefix}MemberAccountRole" # include path prefix without starting /
}


module "reporting-admin-standalone" {
  source                             = "./modules/reporting-admin-module"
  name_prefix                        = local.name_prefix
  custom_tags                        = local.tags
  lambda_logs_level                  = "DEBUG"
  lambda_alias_name                  = local.lambda_alias_name
  lambda_logs_retention_days         = "1"
  data_ingestion_schedule_expression = "rate(3 days)"
  admin_account_role_name            = local.admin_account_role_name
  member_account_role_name           = local.member_account_role_name
}


module "reporting-member-standalone" {
  depends_on = [
    module.reporting-admin-standalone
  ]
  source                   = "./modules/reporting-member-single-module"
  custom_tags              = local.tags
  name_prefix              = local.name_prefix
  admin_account_role_arn   = module.reporting-admin-standalone.admin_role_arn
  member_account_role_name = local.member_account_role_name
}

module "config" {
  source  = "cloudposse/config/aws"
  version = "0.18.0"
  # insert the 2 required variables here

  global_resource_collector_region = var.region_name
  region =var.region
}

module "securityhub" {
  source = "cloudposse/security-hub/aws"
  version = "0.10.0"
  region = var.region

  create_sns_topic = true
  subscribers = {
    opsgenie = {
      protocol               = "https"
      endpoint               = "https://api.example.com/v1/"
      endpoint_auto_confirms = true
      raw_message_delivery   = false
    }
  }
}

module "ssm-parameter-store_example_complete" {
  source  = "cloudposse/ssm-parameter-store/aws//examples/complete"
  version = "0.11.0"
  # insert the 2 required variables here
  parameter_write = var.parameter_write
  region = var.region

}

resource "aws_auditmanager_organization_admin_account_registration" "example" {
  admin_account_id = "012345678901"
}
module "Guardduty" {
  source = "./Modules/guardduty"
  guardduty_enabler = var.guardduty_enabler
  s3_logs_enabler = var.s3_logs_enabler
  kubernetes_audit_logs_enabler = var.kubernetes_audit_logs_enabler
  malware_protection_enabler = var.malware_protection_enabler
  environment = var.environment  
}

module "acm_example_complete-dns-validation" {
  source  = "terraform-aws-modules/acm/aws//examples/complete-dns-validation"
  version = "4.3.2"
}

resource "aws_kms_key" "a" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}

module "iam" {
  source    = "./modules/IAM"
  user_1_name = var.iam_user1
  user_2_name = var.iam_user2
  iam_group_name = var.group_name
}