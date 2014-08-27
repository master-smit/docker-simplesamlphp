#!/bin/bash

####################
# Prerequisites

apt-get update
apt-get install -y git subversion curl htop

####################
# apache2 server
apt-get install -y apache2
apt-get install -y apache2-doc apache2-suexec-pristine apache2-suexec-custom apache2-utils openssl-blacklist
apt-get install -y php-pear libmcrypt-dev mcrypt php5-user-cache
apt-get install -y php5 libapache2-mod-php5 php5-mcrypt
apt-get install -y php5-common php5-cli php5-curl php5-gmp php5-ldap
apt-get install -y libapache2-mod-gnutls

#sudo apt-get install -y mysql-server libapache2-mod-auth-mysql php5-mysql

a2enmod gnutls

/etc/init.d/apache2 restart


####################
# PKI
mkdir -p /etc/ssl/private/
openssl req -x509 -batch -nodes -newkey rsa:2048 -keyout /etc/ssl/private/server.pem -out /etc/ssl/private/server.crt

####################
# SimpleSaml

cd /var
git clone https://github.com/simplesamlphp/simplesamlphp.git
cd /var/simplesamlphp
mkdir -p config && cp -r config-templates/* config/
mkdir -p metadata && cp -r metadata-templates/* metadata/
cp /vagrant/etc/simplesamlphp/config.php /var/simplesamlphp/config/config.php
cp /vagrant/etc/simplesamlphp/authsources.php /var/simplesamlphp/config/authsources.php
cp /vagrant/etc/simplesamlphp/saml20-idp-remote.php /var/simplesamlphp/metadata/saml20-idp-remote.php
cp /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf.bak
cp /vagrant/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf


####################
# Composer
echo "extension=mcrypt.so" >> /etc/php5/cli/php.ini
echo "extension=mcrypt.so" >>  /etc/php5/mods-available/mcrypt.ini
php5enmod mcrypt

curl -sS https://getcomposer.org/installer | php
sudo php composer.phar install

/etc/init.d/apache2 restart
