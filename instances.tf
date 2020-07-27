resource "aws_instance" "instances" {
  count = 3
  
  ami = "ami-0fc61db8544a617ed"
  instance_type = "t2.micro"
  
  subnet_id = element(aws_subnet.public.*.id, count.index)
  
  key_name = "bootcamp"
  
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.database.id, aws_security_group.allow_outbound.id, aws_security_group.allow_app.id]
  
  user_data = templatefile("${path.module}/install_app.tmpl", {database_endpoint = module.rds.this_db_instance_endpoint})
  
  tags = {
    Name = "bootcamp_instances"
  }
}

output "public_ips" {
  value = join(", ", aws_instance.instances.*.public_ip)
}