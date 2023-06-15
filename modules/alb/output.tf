output "resource_arn" {
  value = aws_lb.test.arn
}
output "security_group_id" {
  value = aws_security_group.lb_securitygroup.id
}