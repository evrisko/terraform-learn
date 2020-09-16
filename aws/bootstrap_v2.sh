#!/bin/bash
echo "----------START--------------------"
yum update -y
yum install -y httpd git mod_ssl
git clone https://github.com/evrisko/web-test.git
cd web-test/ && cp * /var/www/html/
cd /etc/pki/tls/certs && ./make-dummy-cert localhost.crt
sed -i 's_SSLCertificateKeyFile /etc/pki/tls/private/localhost.key_#SSLCertificateKeyFile /etc/pki/tls/private/localhost.key/_' /etc/httpd/conf.d/ssl.conf
EC2_AVAIL_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
PrivateIP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo "<h3>Hostname: $(hostname -f)</h3>" >> /var/www/html/index.html
echo "Availability-zone: $EC2_AVAIL_ZONE" >> /var/www/html/index.html
echo "<br>PrivateIP: $PrivateIP" >> /var/www/html/index.html
systemctl start httpd.service
systemctl enable httpd.service
echo "----------FINISH-------------------"
