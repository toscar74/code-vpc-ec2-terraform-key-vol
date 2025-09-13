#!/bin/bash
# Update system
yum update -y

# Install Apache, Git, Wget, Unzip
yum install -y httpd git wget unzip

# Start & enable Apache
systemctl start httpd
systemctl enable httpd

# Download your project (replace with your repo if different)
cd /opt
wget https://github.com/kserge2001/web-consulting/archive/refs/heads/dev.zip
unzip dev.zip

# Copy website files
cp -r /opt/web-consulting-dev/* /var/www/html/

# Set permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Create a fallback index.html if repo is empty
echo "<h1>Hello from EC2 Web Server 🚀</h1>" > /var/www/html/index.html
