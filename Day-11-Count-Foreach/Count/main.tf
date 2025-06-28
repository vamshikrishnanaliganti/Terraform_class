provider "aws" {
  
}
#example1:without list varaible 
# resource "aws_instance" "dev" {
#   ami                    = "ami-019374baf467d6601" # give your amiid
#   instance_type          = "t2.micro"
#   key_name               = "LondonKP"
#   count = 2 # two instances will be created
# #   tags = {
# #     Name="counttf" # two instances name will be same
# #   }
#   tags = {
#     Name="counttf-${count.index}" # two instances will be in the name ex:counttf-0 and counttf-1
#   }
# }

# example-2 with variables list of string 

# variable "ami" {
#   type    = string
#   default = "ami-019374baf467d6601"
# }

# variable "instance_type" {
#   type    = string
#   default = "t2.micro"
# }

# variable "name" {
#   type    = list(string)
#   default = [ "dev", "test"]
# }

# # main.tf
# resource "aws_instance" "teams" {
#   ami           = var.ami
#   instance_type = var.instance_type
#   count         = length(var.name)

#   tags = {
#     Name = var.name[count.index]
#   }
# }

#example-3 creating IAM users 
# variable "user_names" {
#   description = "IAM usernames"
#   type        = list(string)
#   default     = ["user1", "user2", "user3"]
# }
# resource "aws_iam_user" "example" {
#   count = length(var.user_names)
#   name  = var.user_names[count.index]
# }


# example-4 with numeric condition in thid condition if ec2 instance = t2.micro only instance will create(count = var.instance_type == "t2.micro" ? 1 : 0) but i am passing t2.nano so ec2 will not create variables.tf
variable "ami" {
  type    = string
  default = "ami-019374baf467d6601"
}

variable "instance_type" {
  type = string
  default = "t2.nano"
# default = "t2.micro"
}

# main.tf
resource "aws_instance" "dev" {
  ami           = var.ami
  instance_type = var.instance_type
  count         = var.instance_type == "t2.micro" ? 1 : 0 # Creates 1 instance if true, 0 otherwise
  tags = {
    Name = "dev_server"
  }
}