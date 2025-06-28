provider "aws" {
  region = "eu-west-2"
}
resource "aws_key_pair" "name" {
    key_name = "testpublic"
    public_key = file("~/.ssh/id_rsa.pub") #here you need to define public key file path
}
resource "aws_instance" "example" {
  ami           = "ami-019374baf467d6601" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  
  key_name = aws_key_pair.name.key_name
 
  # User data for basic web server setup
  provisioner "remote-exec" {
    inline = [
      # Wait until yum is free
      "while sudo fuser /var/run/yum.pid >/dev/null 2>&1; do echo 'Waiting for yum...'; sleep 5; done",
      
      # Update and install necessary packages
      "sudo yum update -y",
      "sudo yum install -y httpd git",

      # Start and enable Apache HTTP server
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",

      # Ensure /var/www/html directory exists
      "sudo mkdir -p /var/www/html",

      # Write to the file
      "echo 'Git installed successfully!' | sudo tee /var/www/html/git_installed.txt"
    ]

    # Connection block
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa") # Path to your private key
      host        = self.public_ip
    }
  }
  # Local-exec provisioner
  provisioner "local-exec" {
    command = "echo Instance created with IP: ${self.public_ip} >> instance_ips.txt"
  }

}
