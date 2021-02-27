#!/bin/bash

ln -s /etc/nginx/sites-available/nginx_on /etc/nginx/sites-enabled/
rm -rf /etc/nginx/sites-enabled/nginx_off
service nginx restart
echo "autoindex on"