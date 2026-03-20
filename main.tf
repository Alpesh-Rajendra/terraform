resource "aws_vpc" "vnet" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "vpc-ondec-b31"
  }
}

resource "aws_subnet" "pub" {
  vpc_id                  = aws_vpc.vnet.id
  cidr_block              = "192.168.0.0/20"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vnet.id
  tags = {
    Name = "igw-vpc-oncdec-b31"
  }
}

resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.vnet.id
  tags = {
    Name = "public-subnet"
  }

  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "rsa" {
  route_table_id = aws_route_table.rt-1.id
  subnet_id      = aws_subnet.pub.id
}


resource "aws_security_group" "sg" {
  name   = "firewall-vpc-b31"
  vpc_id = aws_vpc.vnet.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "vm" {
  ami                    = "ami-05f071c65e32875a8"
  instance_type          = "t3.micro"
  key_name               = "pankaj"
  subnet_id              = aws_subnet.pub.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data              = <<-EOF
     #!/bin/bash
     sudo -i
     yum install httpd -y
     systemctl start httpd
     echo "Hello Terraform Happpy New Year" > /var/www/html/index.html
    EOF
  tags = {
    Name = "TF-Server"
  }
}
