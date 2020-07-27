# Create a VPC
resource "aws_vpc" "bootcamp" {
  cidr_block = "192.168.0.0/16"
  tags = {
      Name = "bootcamp"
  }
}

resource "aws_subnet" "private" {
  count = 3
  
  vpc_id = aws_vpc.bootcamp.id
  cidr_block        = cidrsubnet(aws_vpc.bootcamp.cidr_block, 8, count.index + 10)
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "bootcamp_private_subnet_${count.index}"
  }
}

resource "aws_subnet" "public" {
  count = 3
    
  vpc_id = aws_vpc.bootcamp.id
  cidr_block        = cidrsubnet(aws_vpc.bootcamp.cidr_block, 8, count.index + 20)
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "bootcamp_public_subnet_${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.bootcamp.id
  tags = {
    Name = "bootcamp_igw"
  }
}

resource "aws_route_table" "route_igw" {
  vpc_id = aws_vpc.bootcamp.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "bootcamp_route_igw"
  }
}

resource "aws_route_table_association" "route_table_association" {
  count          = 3
  route_table_id = aws_route_table.route_igw.id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}
