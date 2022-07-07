#! /bin/bash
# script to setup your jenkins server on a vm

sudo apt update -y && sudo apt-get update

sudo apt install openjdk-11-jdk

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add

sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' 

sudo apt update

sudo apt install jenkins

sudo systemctl start jenkins

sudo systemctl status jenkins

sleep 10

sudo ufw allow 8080

sudo ufw status

sudo cat /var/lib/jenkins/secrets/initialAdminPassword
