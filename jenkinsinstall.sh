#!/bin/bash
sudo yum install -y java-17-amazon-corretto.x86_64
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum -y upgrade
sudo yum install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo yum install -y git