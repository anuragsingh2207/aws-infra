#VPC
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc1"
  }
}

#Subnet
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet1"
  }
}


#SG
resource "aws_security_group" "sg1" {
  name        = "sg1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.vpc1.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg1"
  }
}


# Key
resource "aws_key_pair" "key1" {
  key_name   = "MUMKEY"
  public_key = var.pub_key
  tags = {
    Name = "key1"
  }
}

#EC2
resource "aws_instance" "instance1" {
  ami                    = var.imageid
  instance_type          = var.instancetype
  key_name               = var.key
  vpc_security_group_ids = ["${aws_security_group.sg1.id}"]
  subnet_id              = aws_subnet.subnet1.id

  tags = {
    Name = "instance1"
  }

  connection {
    user        = "ec2-user"
    private_key = file(var.private_key_path)

  }

}

#Internet Gateway
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "igw1"
  }
}

#Elastic IP
resource "aws_eip" "eip1" {
  instance = aws_instance.instance1.id
  domain   = "vpc"
}
