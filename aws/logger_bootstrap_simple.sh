#!/bin/bash
echo "############################### START"
yum -y install python-pip git
pip install ansible
cd /home/ec2-user
git clone https://github.com/evrisko/ansible-ec2.git
echo "############################### FINISH"
