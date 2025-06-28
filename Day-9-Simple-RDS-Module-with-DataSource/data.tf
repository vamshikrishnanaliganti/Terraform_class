# Retrive subnet information of public-2a
data "aws_subnet" "subnet2a" {
  filter {
    name   = "tag:Name"
    values = ["subnet-1"] # Change to your subnet name
  }
}

data "aws_subnet" "subnet2b" {
  filter {
    name   = "tag:Name"
    values = ["subnet-2"] # Change to your subnet name
  }
}
