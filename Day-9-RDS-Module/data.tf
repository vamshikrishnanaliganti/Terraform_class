data "aws_subnet" "subnet-1" {
  filter {
    name   = "tag:Name"
    values = ["subnet-1"] # insert value here
  }
}
data "aws_subnet" "subnet-2" {
  filter {
    name   = "tag:Name"
    values = ["subnet-2"] # insert value here
  }
}