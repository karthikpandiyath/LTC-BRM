variable "vpc_cidr" {
  default = "192.168.0.0/24"
}
variable "public_subnet_count" {
  type = string
}
variable "private_subnet_count" {
  type = string
}
variable "availability_zones" {
  type        = list(string)
  default = [ "ap-south-1a","ap-south-1b" ]
}
variable "public_cidr_block" {
  description = "The endpoints of the service"
  type        = list(string)
  default     = ["192.168.0.0/27", "192.168.0.32/27"]
}
variable "private_cidr_block" {
  description = "The endpoints of the service"
  type        = list(string)
  default     = ["192.168.0.64/27", "192.168.0.96/27"]
}
variable "public_subnet_name" {
  type = list(string)
  default = [ "az1","az2" ]
}
variable "private_subnet_name" {
  type = list(string)
  default = [ "az1","az2" ]
}
variable "private_db_cidr_block" {
  description = "The endpoints of the service"
  type        = list(string)
  default     = [ "192.168.0.128/28", "192.168.0.144/28"]
}
variable "private_db_subnet_name" {
  type = list(string)
  default = [ "az1","az2" ]
}
variable "igw_name" {
  default = "IR-Prod-VPC_igw"
}
variable "private_db_name" {
  type = list(string)
  default = [ "az1","az2" ]
}

variable "private_db_cidr_block1" {
  type = string
}

variable "private_db_cidr_block2" {
  type = string
}

