resource "aws_key_pair" "name" {
    key_name = "LondonKP" # give your keyname associated with ami location
    public_key = file("~/.ssh/id_rsa.pub") #here you need to define public key file path
}

resource "aws_instance" "dev" {
  ami                    = "ami-019374baf467d6601" # give your amiid
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.name.key_name
  tags = {
    Name="key-tf" # you can give any name here 
  }
}
