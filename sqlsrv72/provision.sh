#!/usr/bin/env bash

### FUNCTIONS

sqlsrv_install() {
  if ! pecl list | grep sqlsrv >/dev/null 2>&1; then
    # Install PHP drivers for SQL Server using PECL.
    echo -e "\nInstalling sqlsrv from PECL..."
    pecl install sqlsrv
  else
    # Already installed; update and print version.
    echo -e "\nUpdating sqlsrv from PECL..."
    pecl upgrade sqlsrv
  fi

  if ! pecl list | grep pdo_sqlsrv >/dev/null 2>&1; then
    # Install PHP drivers for PDO SQL Server using PECL.
    echo -e "\nInstalling pdo_sqlsrv from PECL..."
    pecl install pdo_sqlsrv
  else
    # Already installed; update.
    echo -e "\nUpdating pdo_sqlsrv from PECL..."
    pecl upgrade pdo_sqlsrv
  fi
}

configure() {
    # TODO don't want to add this every time; try to get it to add these lines
    # only if they don't already exist
    # 1. Find out if pecl installs these config files
    # 2. Check it these lines are getting duplicated on repeat provisions
    # 2. If yes, then maybe use grep to check first
    # 3. If no, then maybe use cp instead and store these configs locally

    # Configure PHP 7.2 to load the MS MS SQL Server drivers in PHP and nginix.
    #
    # Load the sqlsrv drivers at PHP startup.
    echo "Configuring sqlsrv driver extensions for PHP..."
    echo "extension=pdo_sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini
    echo "extension=sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20-sqlsrv.ini

    # Load the sqlsrv drivers in nginx.
    echo "Configuring sqlsrv driver extensions for nginx..."
    echo "extension=sqlsrv.so" >> /etc/php/7.2/fpm/conf.d/20-sqlsrv.ini
    echo "extension=pdo_sqlsrv.so" >> /etc/php/7.2/fpm/conf.d/30-pdo_sqlsrv.ini
}

services_restart() {
    echo -e "\nRestart services..."
    service nginx restart
    service php7.2-fpm restart
}

sqlsrv_install
configure
services_restart
