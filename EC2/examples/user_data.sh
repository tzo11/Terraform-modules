#!/bin/bash
# ============================================================================
# EC2 Module - Example User Data Script for Linux
# ============================================================================
# This script runs when EC2 instances start up
# Copy this to your root directory as user_data.sh
# Reference in terraform.tfvars: user_data = file("${path.module}/user_data.sh")

set -e

# Log all output
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "=========================================="
echo "Starting EC2 Instance Initialization"
echo "Instance ID: $(ec2-metadata --instance-id | cut -d' ' -f2)"
echo "Hostname: $(hostname)"
echo "=========================================="

# Update system
echo "Updating system packages..."
yum update -y
yum install -y wget curl git htop

# Install Docker
echo "Installing Docker..."
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install Docker Compose
echo "Installing Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d'"' -f4)
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install CloudWatch Agent (Optional)
echo "Installing CloudWatch Agent..."
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm

# Create application directory
mkdir -p /opt/myapp
cd /opt/myapp

# Example: Clone repository (uncomment and customize)
# echo "Cloning application repository..."
# git clone https://github.com/your-repo/your-app.git .

# Example: Start Docker container (uncomment and customize)
# echo "Starting Docker containers..."
# docker-compose up -d

# Create status file
echo "Initialization complete!" > /var/log/user-data-complete

echo "=========================================="
echo "EC2 Instance Initialization Finished"
echo "=========================================="
