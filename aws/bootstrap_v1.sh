#!/bin/bash
echo "----------START--------------------"
yum update -y
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
EC2_AVAIL_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
PrivateIP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo "<h3>Hostname: $(hostname -f)</h3>" > /var/www/html/index.html
echo "Availability-zone: $EC2_AVAIL_ZONE" >> /var/www/html/index.html
echo "<br>PrivateIP: $PrivateIP" >> /var/www/html/index.html
echo "----------FINISH-------------------"
