# Dockerfile
FROM debian:buster

# Install necessary packages
RUN apt-get update && apt-get install -y \
	wget \
	unzip \
	php-fpm \
	php-mysql \
	php-gd \
	php-cli \
	php-cgi \
	curl \
	default-mysql-client

# Download and extract WordPress
WORKDIR /var/www/html

COPY conf/www.conf /etc/php/7.3/fpm/pool.d/

#Create the folder to enable php start
RUN mkdir /run/php

# Configure PHP-FPM
RUN echo "cgi.fix_pathinfo=0" >> /etc/php/7.3/fpm/php.ini
RUN echo "upload_max_filesize = 64M" >> /etc/php/7.3/fpm/php.ini
RUN echo "post_max_size = 64M" >> /etc/php/7.3/fpm/php.ini
RUN echo "max_execution_time = 600" >> /etc/php/7.3/fpm/php.ini

# Copy start script from the correct location
COPY conf/create-config.sh /start.sh
RUN chmod +x /start.sh

# Expose the port php-fpm is reachable on
EXPOSE 9000

ENTRYPOINT [ "/start.sh" ]

# Start php-fpm
CMD ["php-fpm7.3", "-F"]
