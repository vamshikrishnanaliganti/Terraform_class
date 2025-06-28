resource "aws_instance" "dev" {
  ami           = var.amiid
  instance_type = var.instancetype
  key_name      = var.keyname
  tags = {
    Name = "TerraformTest"
  }

}