#!/bin/bash
# Runs once as root when the server first boots. Log: /var/log/user-data.log
exec > /var/log/user-data.log 2>&1
set -x
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y fontconfig openjdk-21-jre curl docker.io

# Jenkins (LTS repo, 2026 signing key)
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
  -o /usr/share/keyrings/jenkins-keyring.asc
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list
apt-get update -y
apt-get install -y jenkins

# Let Jenkins and the ubuntu user run Docker
usermod -aG docker jenkins
usermod -aG docker ubuntu
systemctl enable --now docker
systemctl restart jenkins

echo "DONE: Jenkins installed" 
