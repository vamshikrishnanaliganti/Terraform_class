variable "region" {
  description = "AWS region"
  type = string
  default = "eu-west-2"
}

variable "vpc-name" {
  description = "VPC Name for our RDS server"
  type = string
  default = "RDS-vpc"
}

variable "igw-name" {
  description = "Internet Gate Way Name for our RDS server"
  type = string
  default = "RDS-igw"
}

variable "subnet-name1" {
  description = "Subnet Name for our RDS server"
  type = string
  default = "RDS-subnet1"
}

variable "subnet-name2" {
  description = "Subnet Name for our RDS server"
  type = string
  default = "RDS-subnet2"
}
variable "rt-name" {
  description = "Route Table Name for our RDS server"
  type = string
  default = "RDS-rt"
}

variable "sg-name" {
  description = "Security Group for our RDS server"
  type = string
  default = "RDS-sg"
}


variable "iam-role" {
  description = "IAM Role for the RDS Server"
  type = string
  default = "RDS-iam-role1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-019374baf467d6601" // Replace with the latest AMI ID for your region
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "EC2 keypair"
  type        = string
  default     = "LondonKP"
}

variable "instance_name" {
  description = "EC2 Instance name for the RDS server"
  type        = string
  default     = "RDS-server"
}
