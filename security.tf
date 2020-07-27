resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.bootcamp.id
  name = "bootcamp_allow_ssh"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "bootcamp_allow_ssh"
  }
}

resource "aws_security_group" "database" {
  vpc_id = aws_vpc.bootcamp.id
  name = "bootcamp_database"
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    self = true
  }
  tags = {
      Name = "bootcamp_database"
  }
}

resource "aws_security_group" "allow_outbound" {
  vpc_id = aws_vpc.bootcamp.id
  name = "bootcamp_allow_outbound"
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "bootcamp_allow_outbound"
  }
}

resource "aws_security_group" "allow_app" {
  vpc_id = aws_vpc.bootcamp.id
  name = "bootcamp_allow_app"
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    self = true
  }
}

resource "aws_security_group" "load_balancer" {
  vpc_id = aws_vpc.bootcamp.id
  name = "bootcamp_load_balancer"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [aws_security_group.allow_app.id]
  }
}