#!/bin/bash
echo "----------START--------------------"
sudo yum update -y
sudo yum install -y awslogs
sudo service awslogs start
sudo systemctl start awslogsd
sudo chkconfig awslogsd on
sudo systemctl enable awslogsd.service
echo "----------FINISH-------------------"
