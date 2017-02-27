#!/bin/bash

echo "Hello!, Let's start"

echo "[CentOS] Yum cleaners... {$::osfamily}/{$::operatingsystem}"
yum clean headers
yum clean packages
yum clean metadata
yum clean all
# yum install yum-plugin-fastestmirror

yum update
yum install vim -y

echo "Installing Apache..."
yum install httpd -y

echo "Installing PHP..."
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm

yum install php55w \
php55w-cli \
php55w-intl \
php55w-mcrypt \
php55w-bcmath \
php55w-cgi \
php55w-common \
php55w-enchant \
php55w-fpm \
php55w-gd \
php55w-geoip \
php55w-gmp \
php55w-imap \
php55w-interbase \
php55w-ldap \
php55w-mbstring \
php55w-odbc \
php55w-opcache \
php55w-pspell \
php55w-readline \
php55w-recode \
php55w-snmp \
php55w-tidy \
php55w-xcache \
php55w-xmlrpc \
php55w-xsl \
-y

service httpd restart

echo "Installing percona database..."
wget http://www.percona.com/downloads/percona-release/redhat/0.1-4/percona-release-0.1-4.noarch.rpm
rpm -ivH percona-release-0.1-4.noarch.rpm

yum install Percona-Server-client-56 Percona-Server-server-56 -y
yum install php55w-mysql -y

touch /var/log/mysql-slow.log
chown mysql.mysql /var/log/mysql-slow.log
chmod 755 /var/log/mysql-slow.log
/etc/init.d/mysql start

service httpd restart

mysql -u root -e "UPDATE mysql.user SET Password=PASSWORD('123') WHERE User='root';FLUSH PRIVILEGES;"
mysql -u root -p123 -e 'DELETE FROM mysql.user WHERE User="";'
mysql -u root -p123 -e 'DELETE FROM mysql.user WHERE User="root" AND Host NOT IN ("localhost", "127.0.0.1", "::1");'
mysql -u root -p123 -e 'DROP DATABASE test;'
mysql -u root -p123 -e 'FLUSH PRIVILEGES;'

service httpd restart

echo "Install Mailhog"
## Install packages
yum install daemonize.x86_64 -y

## Install mailhog
wget https://github.com/mailhog/MailHog/releases/download/v0.2.0/MailHog_linux_amd64
chmod +x MailHog_linux_amd64
chown root:root MailHog_linux_amd64
mv MailHog_linux_amd64 /usr/sbin/mailhog

## Install mailhog initd service
wget https://gist.githubusercontent.com/paolooo/811b5189fe29c93e8405298383aa5034/raw/b29dd7ca21c061eb6c912b93a907548f061fd0ea/mailhog.init.j2
chown root:root mailhog.init.j2
chmod +x mailhog.init.j2
mv mailhog.init.j2 /etc/init.d/mailhog

## Start mailhog
chkconfig mailhog on
service mailhog start

echo "Installing Adminer 4.2.2..."
cd /tmp
wget https://www.adminer.org/static/download/4.2.2/adminer-4.2.2.php
mkdir -p /var/www/html/adminer
mv adminer-4.2.2.php /var/www/html/adminer/index.php
