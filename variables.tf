variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance. Defaults to the latest Amazon Linux 2 AMI if not set."
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Name of an existing EC2 key pair to enable SSH access to the instance"
  type        = string
  default     = ""
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "nginx-server"
}

variable "vpc_id" {
  description = "ID of the VPC to deploy the instance into. Uses the default VPC if not set."
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "ID of the subnet to deploy the instance into. Uses a default subnet if not set."
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed to SSH into the instance. Defaults to all IPs — restrict to your own IP range in production."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_http_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the nginx server over HTTP. Defaults to all IPs for a publicly accessible web server — restrict as needed."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
