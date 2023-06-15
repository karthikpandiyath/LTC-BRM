
output "admin_account_id" {
  value = module.reporting-admin-standalone.admin_account_id
}

output "admin_region" {
  value = module.reporting-admin-standalone.admin_region_name
}

output "admin_s3_arn" {
  value = module.reporting-admin-standalone.s3_arn
}

output "member_account_id" {
  value = module.reporting-member-standalone.account_id
}

output "member_region_name" {
  value = module.reporting-member-standalone.region_name
}

output "instance_ids" {
  value = module.ec2_instances.instance_ids
}