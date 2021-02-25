FROM debian:buster

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget
RUN apt-get -y install nginx
RUN apt-get -y install openssl
RUN apt-get -y install php7.3 php-fpm php-mysql php-cli php-gd php-pdo php-mbstring
RUN apt-get -y install mariadb-server


EXPOSE 80 443

RUN mkdir -p var/www/html/
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*
RUN touch /var/www/html/index.php
RUN echo "<?php phpinfo(); ?>" >> /var/www/html/index.php

# SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj "/C=ru/ST=Tatarstan/L=Kazan/O=no/OU=no/CN=pantigon/" \
	-keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

# nginx
COPY ./srcs/nginx etc/nginx/sites-available/nginx
RUN ln -s /etc/nginx/sites-available/nginx /etc/nginx/sites-enabled/nginx
RUN rm -rf /etc/nginx/sites-enabled/default

#MySQL
RUN service mysql start \
    && mysql -u root --skip-password\
	&& mysql -execute="CREATE DATABASE pantigon_db; \
						GRANT ALL PRIVILEGES ON pantigon_db.* TO 'root'@'localhost'; \
						FLUSH PRIVILEGES; \
						UPDATE mysql.user SET plugin = '' WHERE user='root';"

WORKDIR var/www/pantigon

#phpMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin


COPY ./srcs/start_server.sh ./

CMD bash start_server.sh
