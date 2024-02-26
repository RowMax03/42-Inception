#!/bin/bash
mysql_install_db

if service mariadb start; then
	echo "MariaDB started"
	# Change configuration for the mariadb
	sed -i "s|skip-networking|# skip-networking|g" /etc/mysql/mariadb.conf.d/50-server.cnf
	sed -i "s|*bind-address\s*=.*|# bind-address=0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf
	sed -i "/[client-server]/a\
		port =  3306\n\
		# socket = /run/mysqld/mysqld.sock\n\
		\n\
		!includedir /etc/mysql/conf.d/\n\
		!includedir /etc/mysql/mariadb.conf.d/\n\
		\n\
		[mysqld]\n\
		user = root\n\
		\n\
		[server]\n\
		bind-address =  0.0.0.0" /etc/mysql/my.cnf

	# Create the database
	# Delete Standard Database
	mariadb -u root -p$DB_ROOT_PW -e "DROP DATABASE IF EXISTS test;"
	# Create the database if it doesn't exist
	mariadb -u root -p$DB_ROOT_PW -e "CREATE DATABASE IF NOT EXISTS $DB_DATABASE;"
	# Create the user if it doesn't exist and grant all privileges
	mariadb -u root -p$DB_ROOT_PW -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
	mariadb -u root -p$DB_ROOT_PW -e "GRANT ALL ON $DB_DATABASE.* TO '$DB_USER'@'%';"
	mariadb -u root -p$DB_ROOT_PW -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PW';"
	mariadb -u root -p$DB_ROOT_PW -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PW' WITH GRANT OPTION; FLUSH PRIVILEGES;"

	# Import Database
	if [ -f /tmp/wordpress.sql ]; then
		mariadb -uroot -p$DB_ROOT_PW $DB_DATABASE < /tmp/wordpress.sql
		echo "Database imported"
	else
		echo "Database not imported"
	fi

	if mysqladmin -u root -p$DB_ROOT_PW shutdown; then
		echo "MariaDB stopped"
	else
		echo "MariaDB failed to stop"
	fi
else
	echo "MariaDB failed to start"
fi

if mariadbd --bind-address=0.0.0.0; then
	echo "MariaDB started as deamon"
else
	echo "MariaDB failed to run"
fi
