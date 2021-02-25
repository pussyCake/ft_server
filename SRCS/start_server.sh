service mysql start
service nginx start
service php7.3-fpm start

# Configure a wordpress database
echo "CREATE DATABASE pantigon_db;"| mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON pantigon_db.* TO 'root'@'localhost' WITH GRANT OPTION;"| mysql -u root --skip-password
echo "FLUSH PRIVILEGES;"| mysql -u root --skip-password
echo "update mysql.user set plugin='' where user='root';"| mysql -u root --skip-password

bash