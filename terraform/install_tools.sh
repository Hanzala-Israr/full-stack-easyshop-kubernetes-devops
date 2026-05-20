#!/bin/bash

# Update system and install core packages (Upgraded to OpenJDK 21)
sudo apt update
sudo apt install -y fontconfig openjdk-21-jre

# New Jenkins installation (Updated with 2026 GPG signing architecture)
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install -y jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins

# Docker installation
sudo apt-get update
sudo apt-get install docker.io -y

# User group permission
# Note: $USER resolves to root during user_data boot, hardcoding 'ubuntu' as well protects access
sudo usermod -aG docker $USER
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins

sudo systemctl restart docker
sudo systemctl restart jenkins

# Install dependencies and Trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release snapd -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install trivy -y

# AWS CLI installation
sudo snap install aws-cli --classic

# Helm installation
sudo snap install helm --classic

# Kubectl installation
sudo snap install kubectl --classic
