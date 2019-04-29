#!/bin/bash

apt update
apt install -y apache2

apt install -y curl
apt install -y mysql-server

apt install -y php libapache2-mod-php php-mysql
systemctl restart apache2

mysql_secure_installation
