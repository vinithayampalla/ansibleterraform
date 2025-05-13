provider "aws" {
    region = "us-west-1"
}
terraform {
  backend "s3" {
    bucket         = "mybackends3bucket123"
    key            = "env/terraform.tfstate"
    region         = "us-east-1"
  }
}


data "aws_vpc" "default" {
  default = true
}
data "aws_subnet" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = ["vpc-0efe557c752b4e15a"]
  }

  filter {
    name   = "availability-zone"
    values = ["us-west-1a"] # Adjust the tag pattern based on your naming convention
  }
}
resource "aws_security_group" "ec2_sg_ssh_http" {
  name        = "myprojectsg"
  description = "Enable the Port 22(SSH) & Port 80(http)and (8080)"
  vpc_id      = data.aws_vpc.default.id

  # ssh for terraform remote exec
  ingress {
    description = "Allow remote SSH from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # enable http
  ingress {
    description = "Allow HTTP request from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  # enable http
  # ingress {
  #   description = "Allow HTTP request from anywhere"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  # }

  #Outgoing request
  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Groups to allow SSH(22) and HTTP(80) and (8080)"
  }
}






resource "aws_instance" "ansible_terraform_jenkinsinstance" {
  ami           = "ami-07d2649d67dbe8900"
  instance_type = "t2.micro"
  tags = {
    Name = "ansible_terraform_jenkinsinstance"
  }
  key_name                    = "mykeypairhanvi"
  subnet_id                   = data.aws_subnet.public_subnets.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg_ssh_http.id]
  associate_public_ip_address = true

  user_data = file("userdata3.sh")

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}
resource "aws_instance" "ansible_terraform_jenkinsinstance2" {
  ami           = "ami-07d2649d67dbe8900"
  instance_type = "t2.micro"
  tags = {
    Name = "ansible_terraform_jenkinsinstance2"
  }
  key_name                    = "mykeypairhanvi"
  subnet_id                   = data.aws_subnet.public_subnets.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg_ssh_http.id]
  associate_public_ip_address = true

  user_data = file("userdata2.sh")

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}
