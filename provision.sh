#!/usr/bin/env bash

# THIS ALL ASSUMES PYTHON 2.7.6
# IF UBUNTU 14.04 decides to ship a different python might need to work around that.


if [ ! -z $1 ]
then
    PROJECT_HOME=$1
else
    PROJECT_HOME=$(pwd)
fi




cd $PROJECT_HOME

apt-get update
apt-get -y install git

# INSTALL LAMP
# apache, php
apt-get -y install apache2
apt-get -y install php5-gd libssh2-php php5-cli php5 libapache2-mod-php5 php5-mcrypt php5-mysql

# mysql, phpmyadmin
DBHOST=localhost
DBNAME=wordpress
DBUSER=root
DBPASSWD=root
echo "mysql-server mysql-server/root_password password $DBPASSWD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | debconf-set-selections
# echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
# echo "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD" | debconf-set-selections
# echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD" | debconf-set-selections
# echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD" | debconf-set-selections
# echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
# apt-get -y install mysql-server-5.5 phpmyadmin
apt-get -y install mysql-server-5.5


# setup mysql and db
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME;"
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD';"
mysql -uroot -p$DBPASSWD -e "FLUSH PRIVILEGES;"
# setup apache2
truncate -s 0 /etc/apache2/mods-enabled/dir.conf
cat > /etc/apache2/mods-enabled/dir.conf << "EOF"
<IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
EOF

# DOWNLOAD AND INSTALL WORDPRESS
wget http://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
rm -r latest.tar.gz
cd wordpress
cp wp-config-sample.php wp-config.php
sed -i -e "s/database_name_here/$DBNAME/g" wp-config.php
sed -i -e "s/username_here/$DBUSER/g" wp-config.php
sed -i -e "s/password_here/$DBPASSWD/g" wp-config.php
sed -i -e "s/localhost/$DBHOST/g" wp-config.php
cd ..
rsync -avP $PROJECT_HOME/wordpress/ /var/www/html/
chgrp -R www-data /var/www/html/
mkdir /var/www/html/wp-content/uploads
chgrp -R www-data /var/www/html/wp-content/uploads
# rm -r /var/www/html
# ln -s $PROJECT_HOME/wordpress /var/www/html
# chown -R :www-data $PROJECT_HOME/wordpress






