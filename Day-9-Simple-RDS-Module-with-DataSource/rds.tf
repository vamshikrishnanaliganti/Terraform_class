module "mysql_db" {
  source               = "terraform-aws-modules/rds/aws"
  allocated_storage    = 20
  identifier           = "testdb"
  db_name              = "demodb"
  engine               = "mysql"
  engine_version       = "8.0.32"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "mypassword123"
  publicly_accessible  = true
  subnet_ids           = [data.aws_subnet.subnet2a.id, data.aws_subnet.subnet2b.id]
  skip_final_snapshot  = true
}
