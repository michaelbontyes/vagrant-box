# MYSQL SETTINGS
MYSQL=1
MYSQL_HOST=localhost
MYSQL_NAME=dbname
MYSQL_USER=dbuser
MYSQL_PASS=dbpass

# APACHE SETTINGS
APACHE=1
APACHE_NAME=Site
APACHE_ROOT=/var/www/site

# WORDPRESS SETTINGS
WORDPRESS=1
WORDPRESS_ROOT=/var/www/site

sudo apt-get update

# MYSQL
if [ "$MYSQL" = 1 ]; then
	sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $MYSQL_PASS"
	sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $MYSQL_PASS"
	
	sudo apt-get -y install mysql-server-5.5
	
	if [ ! -f /var/log/databasesetup ]; then
		mysql -u root -p$MYSQL_PASS -e "CREATE DATABASE $MYSQL_NAME;"
		mysql -u root -p$MYSQL_PASS -e "CREATE USER '$MYSQL_USER'@'$MYSQL_HOST' IDENTIFIED BY '$MYSQL_PASS';"
		mysql -u root -p$MYSQL_PASS -e "GRANT ALL PRIVILEGES ON $MYSQL_NAME.* TO '$MYSQL_USER'@'$MYSQL_HOST';"
		mysql -u root -p$MYSQL_PASS -e "FLUSH PRIVILEGES;"
		touch /var/log/databasesetup
	fi
fi

# APACHE
if [ "$APACHE" = 1 ]; then
	sudo apt-get -y install apache2 php5 php5-mysql
	
	if [ ! -h /var/www ]; then 
		ln -s /vagrant/public /var/www
		a2enmod rewrite
		sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default
		cat > /etc/apache2/sites-enabled/000-default.conf <<EOF
	<VIRTUALHOST *:80>
		ServerAdmin webmaster@localhost
		ServerName $APACHE_NAME
		DocumentRoot $APACHE_ROOT
		<DIRECTORY />
			Options FollowSymLinks
			AllowOverride None
		</DIRECTORY>
		<DIRECTORY $APACHE_ROOT>
			Options +FollowSymLinks
			AllowOverride All
		</DIRECTORY>
		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined
		SetEnv APP_ENV local
		SetEnv DB_HOST $MYSQL_HOST
		SetEnv DB_NAME $MYSQL_NAME
		SetEnv DB_USER $MYSQL_USER
		SetEnv DB_PASS $MYSQL_PASS
	</VIRTUALHOST>
	EOF
		service apache2 restart
	fi
fi

# WORDPRESS
if [ "$WORDPRESS" = 1 ]; then
	if [ ! -d "$WORDPRESS_ROOT/wp-admin" ]; then
		cd $WORDPRESS_ROOT
		wget http://wordpress.org/latest.tar.gz
		tar xvf latest.tar.gz
		mv wordpress/* ./
		rmdir ./wordpress/
		rm -f latest.tar.gz
	fi
fi

sudo apt-get upgrade