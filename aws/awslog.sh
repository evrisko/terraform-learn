#!/bin/bash
echo "----------START--------------------"
yum update -y
yum install -y awslogs
service awslogs start
systemctl start awslogsd
chkconfig awslogsd on
systemctl enable awslogsd.service
echo "----------FINISH-------------------"
