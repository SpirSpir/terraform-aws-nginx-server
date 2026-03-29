#!/bin/bash
set -e

# Update system packages
yum update -y

# Install nginx
amazon-linux-extras enable nginx1
yum install -y nginx

# Start and enable nginx
systemctl start nginx
systemctl enable nginx

# Allow HTTP traffic through the firewall (if firewalld is active)
if systemctl is-active --quiet firewalld; then
  firewall-cmd --permanent --add-service=http
  firewall-cmd --reload
fi
