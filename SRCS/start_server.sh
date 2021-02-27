 service mysql start
service nginx start
service php7.3-fpm start
service php7.3-fpm status

echo "CREATE DATABASE pantigon;" | mysql -u root
echo "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';" | mysql -u root
echo "GRANT ALL ON wordpress.* TO 'admin'@'localhost';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
echo "UPDATE mysql.user SET plugin='mysql_native_password' WHERE user='admin';" mysql -u root

bash