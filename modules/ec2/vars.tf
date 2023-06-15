# variables.tf

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-xxxxxxxxxxxxxxxxx"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instances"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the EC2 instances"
  type        = string
}
