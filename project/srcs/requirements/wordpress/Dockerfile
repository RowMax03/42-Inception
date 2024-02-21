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
	php-cgi

# Download and extract WordPress
WORKDIR /var/www/html

COPY conf/www.conf /etc/php/7.3/fpm/pool.d/

#Create the folder to enable php start
RUN mkdir /run/php

RUN wget http://wordpress.org/latest.tar.gz && \
	tar xfz latest.tar.gz && \
	mv wordpress/* . && \
	rm -rf latest.tar.gz && \
	rm -rf wordpress

# Configure PHP-FPM
RUN echo "cgi.fix_pathinfo=0" >> /etc/php/7.3/fpm/php.ini
RUN echo "upload_max_filesize = 64M" >> /etc/php/7.3/fpm/php.ini
RUN echo "post_max_size = 64M" >> /etc/php/7.3/fpm/php.ini
RUN echo "max_execution_time = 600" >> /etc/php/7.3/fpm/php.ini

# Expose the port php-fpm is reachable on
EXPOSE 9000

# Start php-fpm
CMD ["php-fpm7.3", "-F"]
