provider "aws" {
  region = var.aws_region
}

# Lookup the latest Amazon Linux 2 AMI when ami_id is not provided
data "aws_ami" "amazon_linux_2" {
  count       = var.ami_id == "" ? 1 : 0
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2[0].id
}

# Security group allowing HTTP and optional SSH access
resource "aws_security_group" "nginx" {
  name        = "${var.instance_name}-sg"
  description = "Security group for nginx server"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : null

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr_blocks
  }

  dynamic "ingress" {
    for_each = var.key_name != "" ? [1] : []
    content {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidr_blocks
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.instance_name}-sg" },
    var.tags
  )
}

# EC2 instance running nginx
resource "aws_instance" "nginx" {
  ami                         = local.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name != "" ? var.key_name : null
  subnet_id                   = var.subnet_id != "" ? var.subnet_id : null
  vpc_security_group_ids      = [aws_security_group.nginx.id]
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = file("${path.module}/user-data.sh")

  tags = merge(
    { Name = var.instance_name },
    var.tags
  )
}
