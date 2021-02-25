FROM debian:buster

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget
RUN apt-get -y install nginx
RUN apt-get -y install openssl
RUN apt-get -y install php-fpm php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
RUN apt-get -y install mariadb-server


EXPOSE 80 443

RUN mkdir -p var/www/pantigon/
RUN chown -R www-data /var/www/*
RUN chmod -R 755 /var/www/*
RUN touch /var/www/pantigon/index.php
RUN echo "<?php phpinfo(); ?>" >> /var/www/pantigon/index.php

# SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj "/C=ru/ST=Tatarstan/L=Kazan/O=no/OU=no/CN=pantigon/" \
	-keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

# nginx
COPY ./SRCS/nginx etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/nginx /etc/nginx/sites-enabled/nginx
RUN rm -rf /etc/nginx/sites-enabled/default

#MySQL
RUN service mysql start \
    && mysql -u root \
	&& mysql -e "CREATE DATABASE pantigon_db; \
						GRANT ALL PRIVILEGES ON wp_base.* TO 'root'@'localhost'; \
						FLUSH PRIVILEGES; \
						UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user='root';"

WORKDIR var/www/pantigon

#phpMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin
COPY ./SRCS/config.inc.php phpmyadmin


COPY ./SRCS/start_server.sh ./

#CMD bash start_server.sh
