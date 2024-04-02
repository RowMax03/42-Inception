#!/bin/bash

# Wait for MariaDB to start
until mysql -h"mariadb" -u"$DB_USER" -p"$DB_PASSWORD" -e 'SELECT 1'; do
	echo "Waiting for MariaDB to start"
	sleep 1
done

## Create wp-config.php
wp core config --dbname="$DB_DATABASE" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost="mariadb" --allow-root

# Set WordPress environment variables
wp config set USE_PERSISTENT_CONNECTION false --raw --type=constant --allow-root
wp config set DB_NAME $DB_DATABASE --type=constant --allow-root
wp config set DB_USER $DB_USER --type=constant --allow-root
wp config set DB_PASSWORD $DB_PASSWORD --type=constant --allow-root
wp config set DB_HOST mariadb --type=constant --allow-root
#mv /var/www/html/wp-config.php /var/www/html/wordpress/wp-config.php

exec "$@"
