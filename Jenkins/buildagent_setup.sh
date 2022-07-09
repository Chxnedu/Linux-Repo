#! /bin/bash
# script to setup your jenkins slave server on a vm

sudo apt update -y && sudo apt-get update

sudo apt install openjdk-11-jdk

echo "What do you want to call the new user?"
read username

sudo useradd -m $username

sudo -u $username mkdir /home/$username/.ssh

echo "Paste public ssh key"
sleep 2

sudo -u $username nano /home/$username/.ssh/authorized_keys


