# #simple for_each example with instance

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
#   #count         = length(var.name)
#   for_each = toset(var.name)

#   tags = {
#     Name = each.value
#   }
# }

# Example 2 for for_each

variable "ami" {
  type    = string
  default = "ami-019374baf467d6601"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}


variable "subnet_id" {
    type = string
    #default = "subnet-06e52282c552d43aa"
    default = "subnet-0391c477a05fa0c98"
  
}
variable "sandboxes" {
  type    = list(string)
  default = ["dev", "prod"]
}

resource "aws_instance" "sandbox" {
  ami           = var.ami
  instance_type = var.instance_type
#   count = length(var.sandboxes)
  for_each      = toset(var.sandboxes)
  # subnet_id = var.subnet_id
#   count = length(var.sandboxes)
  tags = {
    Name = each.value # for a set, each.value and each.key is the same
  }
}