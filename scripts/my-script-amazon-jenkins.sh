#!/bin/bash

# --------------------------------------------------------------
# Author: Frank Effrim-Botchey
# installs Apache, Java, Jenkins & starts all of those services
# Can be used on an Amazon AMI
# --------------------------------------------------------------

sudo yum update -y

sudo yum install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd
sudo systemctl start apache2

sudo yum install default-jre
sudo yum install default-jdk
java -version

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo yum-key add -
echo 'deb https://pkg.jenkins.io/debian-stable binary/' | sudo tee -a /etc/apt/sources.list
sudo yum update -y
sudo yum install jenkins -y
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
sudo systemctl start jenkins
sudo systemctl status jenkins

echo "<html><body><div>Welcome to the Jenkins Server (${my-scriptfile}) </div></body></html>" > /var/www/html/index.html
