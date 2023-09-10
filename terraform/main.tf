#VPC
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc1"
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
    Name = "allow_tls"
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
  ami             = var.imageid
  instance_type   = var.instancetype
  key_name        = var.key
  security_groups = ["${aws_security_group.sg1.name}"] #Resource outputs

  tags = {
    Name = "instance1"
  }

  connection {
    user        = "ec2-user"
    private_key = file(var.private_key_path)

  }

}