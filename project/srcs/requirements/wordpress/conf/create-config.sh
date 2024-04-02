#!/bin/bash

#check if wp-config.php exist
if [ -f ./wp-config.php ]
then
	echo "wordpress already downloaded"
else

####### MANDATORY PART ##########

	#Download wordpress and all config file
	wget http://wordpress.org/latest.tar.gz
	tar xfz latest.tar.gz
	mv wordpress/* .
	rm -rf latest.tar.gz
	rm -rf wordpress

	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# Wait for MariaDB to start
until mysql -h"mariadb" -u"$DB_USER" -p"$DB_PASSWORD" -e 'SELECT 1'; do
	echo "Waiting for MariaDB to start"
	sleep 1
done

cd wordpress/

## Create wp-config.php
wp core config --dbname="$DB_DATABASE" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost="mariadb" --allow-root

# Set WordPress environment variables
wp config set USE_PERSISTENT_CONNECTION false --raw --type=constant --allow-root
wp config set DB_NAME $DB_DATABASE --type=constant --allow-root
wp config set DB_USER $DB_USER --type=constant --allow-root
wp config set DB_PASSWORD $DB_PASSWORD --type=constant --allow-root
wp config set DB_HOST mariadb --type=constant --allow-root
#mv /var/www/html/wp-config.php /var/www/html/wordpress/wp-config.php
fi

exec "$@"
