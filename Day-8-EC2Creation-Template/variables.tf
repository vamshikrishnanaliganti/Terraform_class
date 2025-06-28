variable "aws_region" {
  description = "AWS region for the EC2 instance"
  default     = "eu-west-2"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = ""
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  default     = "my-ec2-instance"
}

variable "key_name" {
  description = "Name of the key pair for SSH access"
  default = ""
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  default = ""
}

# variable "security_group_ids" {
#   description = "List of security group IDs for the EC2 instance"
#   type        = list(string)
# }

