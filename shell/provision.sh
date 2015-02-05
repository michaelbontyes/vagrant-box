# VARIABLES
APPENV=local
DBHOST=localhost
DBNAME=dbname
DBUSER=dbuser
DBPASS=dbpass

WORDPRESS=1

sudo apt-get update

# MYSQL
sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $DBPASS"
sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $DBPASS"

sudo apt-get -y install mysql-server-5.5

if [ ! -f /var/log/databasesetup ]; then
	mysql -u root -p$DBPASS -e "CREATE DATABASE $DBNAME;"
	mysql -u root -p$DBPASS -e "CREATE USER '$DBUSER'@'$DBHOST' IDENTIFIED BY '$DBPASS';"
	mysql -u root -p$DBPASS -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'$DBHOST';"
	mysql -u root -p$DBPASS -e "FLUSH PRIVILEGES;"
	touch /var/log/databasesetup
fi

# APACHE
sudo apt-get -y install apache2 php5 php5-mysql

if [ ! -h /var/www ]; then 
	ln -s /vagrant/public /var/www
	a2enmod rewrite
	sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default
	cat > /etc/apache2/sites-enabled/000-default.conf <<EOF
<VIRTUALHOST *:80>
	ServerAdmin webmaster@localhost
	ServerName SITES
	DocumentRoot /var/www/site
	<DIRECTORY />
	Options FollowSymLinks
	AllowOverride None
	</DIRECTORY>
	<DIRECTORY /var/www/site/>
	Options +FollowSymLinks
	AllowOverride All
	</DIRECTORY>
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
	SetEnv APP_ENV $APPENV
	SetEnv DB_HOST $DBHOST
	SetEnv DB_NAME $DBNAME
	SetEnv DB_USER $DBUSER
	SetEnv DB_PASS $DBPASS
</VIRTUALHOST>
EOF
	service apache2 restart
fi

# WORDPRESS
if [ "$WORDPRESS" = 1 ]; then
	if [ ! -d /var/www/site/wp-admin ]; then
		cd /var/www/site
		wget http://wordpress.org/latest.tar.gz  
		tar xvf latest.tar.gz 
		mv wordpress/* ./  
		rmdir ./wordpress/  
		rm -f latest.tar.gz
	fi
fi

sudo apt-get upgrade