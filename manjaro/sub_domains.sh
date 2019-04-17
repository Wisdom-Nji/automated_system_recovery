#!/bin/bash

subdomain_name=''
read -p "Sub Domain Name (be sure to end with .localhost: " subdomain_name

mkdir /srv/http/${subdomain_name}

echo -e "Uncomment the following line in the file /etc/httpd/conf/httpd.conf\n\tInclude conf/extra/httpd-vhosts.conf"
read -n 1 -s -r -p "Press any key when ready..."
sudo vim /etc/httpd/conf/httpd.conf

echo -e "\
	<VirtualHost *:80>\n\
	    ServerAdmin webmaster@${subdomain_name}\n\
	    DocumentRoot "/srv/http/${subdomain_name}"\n\
	    ServerName ${subdomain_name}\n\
	    ServerAlias www.${subdomain_name}\n\
	    ErrorLog "/var/log/httpd/domain1.com-error_log"\n\
	    CustomLog "/var/log/httpd/domain1.com-access_log" common\n\
	</VirtualHost>" >> /etc/httpd/conf/extra/httpd-vhosts.conf
if apachectl configtest
then
	sudo echo -e "127.0.0.1\t${subdomain_name}" >> /etc/hosts
	sudo systemctl restart httpd
	echo -e "\nWell done!!\n\n"
fi
