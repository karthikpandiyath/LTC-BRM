variable "vpc_cidr" {
  default = "10.0.0.0/22"
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
  default     = ["10.0.0.0/25", "10.0.0.128/25"]
}
variable "private_cidr_block" {
  description = "The endpoints of the service"
  type        = list(string)
  default     = ["10.0.1.0/25", "10.0.1.128/25","10.0.2.0/25","10.0.2.128/25"]
}
variable "public_subnet_name" {
  type = list(string)
  default = [ "public_subnet_az1","public_subnet_az2" ]
}
variable "private_subnet_name" {
  type = list(string)
  default = [ "private_app_subnet_az1","private_app_subnet_az2","private_db_subnet_az1","private_db_subnet_az2" ]
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = list
  default     = ["ami-xxxxxxxxxxxxxxxxx","ami-xxxxxxxxxxxxxxxxx","ami-xxxxxxxxxxxxxxxxx",
  "ami-xxxxxxxxxxxxxxxxx"]

}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instances"
  type        = string
}

variable "area_zone" {
  type =list
  default=["ap-southeast-1a","ap-southeast-1b"]
  
}




###Variables for EC2###
variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default = "1"

}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default = "t3.micro"
}
variable "subnet_id" {
  description = "Subnet ID for the EC2 instances"
  type        = string
}

variable "area_zone" {
  type =list
  default=["ap-southeast-1a","ap-southeast-1b"]
  
}

variable "guardduty_enabler" {
    description = "Guardduty enable or disable"
}
variable "s3_logs_enabler" { 
    description = "S3 logs enable or disable"
}
variable "kubernetes_audit_logs_enabler" {
    description = "Kubernetes logs enable or disable"
}
variable "malware_protection_enabler" {
    description = "Malware Protection enable or disable"  
}
variable "environment" {
    description = "Name of the Environment" 
}