FROM debian:buster

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget
RUN apt-get -y install nginx
RUN apt-get -y install openssl
RUN apt-get -y install php7.3 php-fpm php-mysql php-cli php-gd php-pdo php-mbstring
RUN apt-get -y install mariadb-server

EXPOSE 80 443

# RUN touch /var/www/html/index.php
# RUN echo "<?php phpinfo(); ?>" >> /var/www/html/index.php


# SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj "/C=ru/ST=Tatarstan/L=Kazan/O=no/OU=no/CN=pantigon/" \
	-keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

WORKDIR var/www/html
RUN rm -rf index.nginx-debian.html 

# nginx
COPY /srcs/nginx_on /etc/nginx/sites-available/nginx_on
COPY /srcs/nginx_off /etc/nginx/sites-available/nginx_off
RUN ln -s /etc/nginx/sites-available/nginx_on /etc/nginx/sites-enabled/
RUN rm -rf /etc/nginx/sites-enabled/default

#phpMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin

#wp
RUN wget https://wordpress.org/latest.tar.gz && tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
COPY ./srcs/wp-config.php wordpress

RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*
COPY ./srcs/start_server.sh ./
COPY ./srcs/index_off.sh ./
COPY ./srcs/index_on.sh ./

CMD bash start_server.sh
