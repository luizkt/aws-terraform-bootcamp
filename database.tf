module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"
  identifier = "bootcamp-rds"
  
  engine = "postgres"
  engine_version = "9.6.9"
  instance_class = "db.t2.micro"
  allocated_storage = "20"
  storage_encrypted = false
  
  name = "bootcamp"
  username = "bootcamp"
  password = "bootcamp2020"
  port = "5432"
  
  multi_az = "false"
  create_db_parameter_group = false
  major_engine_version = "9.6"
  family = "postgres9.6"
  
  maintenance_window = "Thu:03:30-Thu:05:30"
  backup_window = "05:30-06:30"
  
  subnet_ids = flatten(chunklist(aws_subnet.private.*.id, 1))
  vpc_security_group_ids = [aws_security_group.database.id]
}

output "database_endpoint" {
  value = module.rds.this_db_instance_endpoint
}
