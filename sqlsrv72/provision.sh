#!/usr/bin/env bash

DIR=`dirname $0`

### FUNCTIONS

sqlsrv_install() {
  echo -e "\nUpdating pecl channel..."
  pecl channel-update pecl.php.net

  if ! pecl list | grep sqlsrv >/dev/null 2>&1; then
    # Install PHP drivers for SQL Server using PECL.
    echo "Installing sqlsrv from pecl..."
    pecl install sqlsrv
  else
    # Already installed; update and print version.
    echo "Updating sqlsrv from pecl..."
    pecl upgrade sqlsrv
  fi

  if ! pecl list | grep pdo_sqlsrv >/dev/null 2>&1; then
    # Install PHP drivers for PDO SQL Server using PECL.
    echo "Installing pdo_sqlsrv from pecl..."
    pecl install pdo_sqlsrv
  else
    # Already installed; update.
    echo "Updating pdo_sqlsrv from pecl..."
    pecl upgrade pdo_sqlsrv
  fi
}

configure() {
  # TODO don't want to add this every time; try to get it to add these lines
  # only if they don't already exist
  # 1. Find out if pecl installs these config files --> it doesn't seem to; could probably cp them instead
  # 2. Check it these lines are getting duplicated on repeat provisions
  #   - Yes, they are getting duplicated with every provision :(
  # 2. If yes, then maybe use grep to check first
  # 3. If no, then maybe use cp instead and store these configs locally

  # Configure to load the sqlsrv drivers at PHP startup.
  echo "Adding sqlsrv and pdo_sqlsrv to php ini..."
  # echo "extension=pdo_sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini
  # echo "extension=sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20-sqlsrv.ini

  # Copy sqlsvr fpm configuration from local.
  # OLD WAY echo "extension=sqlsrv.so" >> /etc/php/7.2/fpm/conf.d/20-sqlsrv.ini
  # OLD WAY echo "extension=pdo_sqlsrv.so" >> /etc/php/7.2/fpm/conf.d/30-pdo_sqlsrv.ini
  cp "${DIR}/php7.2-sqlsrv.ini" "/etc/php/7.2/cli/conf.d/20-sqlsrv.ini"
  cp "${DIR}/php7.2-pdo_sqlsrv.ini" "/etc/php/7.2/cli/conf.d/30-pdo_sqlsrv.ini"
  cp "${DIR}/php7.2-sqlsrv.ini" "/etc/php/7.2/fpm/conf.d/20-sqlsrv.ini"
  cp "${DIR}/php7.2-pdo_sqlsrv.ini" "/etc/php/7.2/fpm/conf.d/30-pdo_sqlsrv.ini"

  echo " * Copied ${DIR}/php7.2-sqlsrv.ini                 to /etc/php/7.2/cli/conf.d/20-sqlsrv.ini"
  echo " * Copied ${DIR}/php7.2-pdo_sqlsrv.ini             to /etc/php/7.2/cli/conf.d/30-pdo_sqlsrv.ini"
  echo " * Copied ${DIR}/php7.2-sqlsrv.ini                 to /etc/php/7.2/fpm/conf.d/20-sqlsrv.ini"
  echo " * Copied ${DIR}/php7.2-pdo_sqlsrv.ini             to /etc/php/7.2/fpm/conf.d/30-pdo_sqlsrv.ini"
}

services_restart() {
    echo -e "\nRestart services..."
    service nginx restart
    service php7.2-fpm restart
}

sqlsrv_install
configure
services_restart
