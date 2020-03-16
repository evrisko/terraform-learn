#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
  yum -y update
  yum -y install python-pip git
  pip install ansible
  cd /home/ec2-user
  git clone https://github.com/evrisko/ansible-ec2.git
