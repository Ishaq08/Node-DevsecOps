variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1" # Mumbai, closest to Pakistan
}

variable "instance_type" {
  description = "EC2 size. Jenkins + Docker needs at least 4 GB RAM."
  type        = string
  default     = "t3.large"
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "jenkins-server"
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR form, e.g. 203.0.113.25/32"
  type        = string
}
