variable "targetname" {
  default = "tf-example-lb-tg"
}
variable "vpc_id" {
}
variable "target_id1" {
}
variable "target_id2" {
}
variable "lb1_name" {
}
variable "subnets" {
}
variable "certificate_arn" {
}
variable "lb1_securitygroup_name" {
  default = "lb1_security_group"
}
variable "port_number_1" {
  default = "80"
}
variable "lb_protocol1" {
  default = "TCP"
}
variable "lb_CIDR_1" {
  default = ["0.0.0.0/0"]
}
variable "port_number_2" {
  default = "443"
}
variable "lb_protocol2" {
  default = "TCP"
}
variable "lb_CIDR_2" {
  default = ["0.0.0.0/0"]
}