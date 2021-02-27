#!/bin/bash

ln -s /etc/nginx/sites-available/nginx_off /etc/nginx/sites-enabled/
rm -rf /etc/nginx/sites-enabled/nginx_on
service nginx restart
echo "autoindex off"