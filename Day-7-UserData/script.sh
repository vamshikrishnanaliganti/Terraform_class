#! /bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo service httpd start  
sudo systemctl enable httpd
echo "<h1>Welcome!! AWS Infra created using Terraform in eu-west-2 Region</h1>" > /var/www/html/index.html