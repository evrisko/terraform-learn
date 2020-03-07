#!/bin/bash
echo "----------START--------------------"
yum update -y
yum install -y awslogs
systemctl start awslogsd
systemctl enable awslogsd.service
echo "----------FINISH-------------------"
