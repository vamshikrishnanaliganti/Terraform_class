variable "amiid" {
  type = string
  description = "ami-id of the ec2 instance"
  default = ""
}
variable "instancetype" {
  type = string
  description = "instance type of the ec2 instance"
  default = ""
}
variable "keyname" {
  type = string
  description = "keyname of the ec2 instance"
  default = ""
}
variable "az" {
  type = string
  description = "availability zone of the ec2 instance"
  default = ""
}