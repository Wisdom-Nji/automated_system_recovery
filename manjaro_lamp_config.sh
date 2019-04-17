#!/bin/bash

#fucking run this as sudo else, don't waste time else you've done a good config... well done


echo -e "Installing Apache......\n"  
if pacman -S apache 
then
	echo "Apache installed\n"
	echo "Edit /etc/httpd/conf/httpd.conf;\n\tsearch and comment out the following line if it not already: # LoadModule unique_id_module modules/mod_unique_id.so"
	read -n 1 -s -r -p "Press any key when ready... vim loading..."
	systemctl enable httpd && systemctl restart httpd

	user_input=''
	read -p "Would you like to check the status [y/n]: " user_input
	if [ "${user_input}" == "y" ] ; then
		systemctl status httpd
	fi
	firefox localhost
else 
	echo -e "Seems shit hit the fan! Failed to install apache!\n"
fi


echo -e "Installing mysql\n"
if pacman -S mariadb 
then
	echo -e "Mysql installed\n"
	sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	systemctl enable mysqld && systemctl start mysqld

	user_input=''
	read -p "Would you like to check the status [y/n]: " user_input
	if [ "${user_input}" == "y" ] ; then
		systemctl status httpd
	fi
	echo -e "\n\nNow to configure you database settings...\n"
	read -n 1 -s -r -p "Press any key when ready..."
	mysql_secure_installation
else 
	echo -e "Seems shit hit the fan! Failed to install mariadb!\n"
fi


echo -e "Installing PHP\n"
if pacman -S php php-apache
then
	echo -e "PHP installed successfully\nNow you have to edit this file: /etc/httpd/conf/httpd.conf\n\nFind the following line and comment it out: \n\t#LoadModule mpm_event_module modules/mod_mpm_event.so\n"
	read -n 1 -s -r -p "Press any key when ready...."
	sudo vim /etc/httpd/conf/httpd.conf
	echo -e "Find the following line and uncomment it or add it if not exist: \n\tLoadModule mpm_prefork_module modules/mod_mpm_prefork.so\n"
	read -n 1 -s -r -p "Press any key when ready..."
	sudo vim /etc/httpd/conf/httpd.conf
	sudo echo -e "\
		LoadModule php7_module modules/libphp7.so\n\
		AddHandler php7-script php\n\
		Include conf/extra/php7_module.conf\n" >> /etc/httpd/conf/httpd.conf
	#could put some php test here... but why bother now lol
	systemctl restart httpd
else 
	echo -e "Seems shit hit the fan! Failed to install php\n"
fi


echo -e "Installing phpmyadmin\n"
if pacman -S phpmyadmin 
then
	echo -e "phpmyadmin installed successfully!\n"
	echo -e "Editing the following file: /etc/php/php.ini\nPlease make sure the following lines are uncommented\n"
	echo -e "\textension=bz2.so\n\textension=mysqli.so"
	read -n 1 -s -r -p "Press any key when ready..."
	sudo vim /etc/php/php.ini
	echo -e "Creating the configuration file\n"
	sudo echo -e "\
		Alias /phpmyadmin \"/usr/share/webapps/phpMyAdmin\"\n\
		<Directory \"/usr/share/webapps/phpMyAdmin\">\n\
		DirectoryIndex index.php\n\
		AllowOverride All\n\
		Options FollowSymlinks\n\
		Require all granted\n\
		</Directory>\n" >> /etc/httpd/conf/extra/phpmyadmin.conf
	sudo echo -e "Include conf/extra/phpmyadmin.conf" >> /etc/httpd/conf/httpd.conf
	sudo systemctl restart httpd
else
	echo -e "Seems shit hit th fan! Failed to install phpmyadmin!"
fi

echo -e "\n\nYOU'VE MADE IT TO THE END... HOW MUCH SHIT GOT FUCKED?? IT'S LEFT TO YOU...\n"
