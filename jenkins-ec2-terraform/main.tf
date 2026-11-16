terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws   = { source = "hashicorp/aws", version = "~> 5.0" }
    tls   = { source = "hashicorp/tls", version = "~> 4.0" }
    local = { source = "hashicorp/local", version = "~> 2.0" }
  }
}

provider "aws" {
  region = var.region
}

# Latest Ubuntu 24.04 AMI (works in any region)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# SSH key pair: Terraform creates it and saves the private key locally
resource "tls_private_key" "jenkins" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jenkins" {
  key_name   = "${var.name}-key"
  public_key = tls_private_key.jenkins.public_key_openssh
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.jenkins.private_key_pem
  filename        = "${path.module}/${var.name}-key.pem"
  file_permission = "0400"
}

# Firewall: only YOUR IP can reach SSH and Jenkins
resource "aws_security_group" "jenkins" {
  name        = "${var.name}-sg"
  description = "SSH and Jenkins access from my IP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name}-sg" }
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.jenkins.key_name
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  user_data              = file("${path.module}/user_data.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = { Name = var.name }
}
