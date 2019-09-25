#!/usr/bin/env bash
# PHP SQLSRV and PDO_SQLSRV extensions
DIR=`dirname $0`

install_sqlsrv() {
  # Supports php =>7.0
  for version in "7.0" "7.1" "7.2" "7.3"
  do
    if [[ $(command -v php$version) ]]; then
      if [[ $( pecl list | grep -w sqlsrv ) ]]; then
        # Already installed, try updating.
        echo "Updating sqlsrv from pecl..."
        pecl -d php_suffix="$version" upgrade sqlsrv > /dev/null 2>&1
      else
        # Install PHP drivers for SQL Server using PECL.
        echo "Installing SQLSRV for PHP $version"
        pecl -d php_suffix="$version" install sqlsrv > /dev/null 2>&1
        # do not remove files, but register packages as not installed to allow installing for multiple PHP versions
        pecl uninstall -r sqlsrv > /dev/null 2>&1
        echo "Copying SQLSRV files for PHP $version"
        cp -f "${DIR}/sqlsrv.ini" "/etc/php/$version/mods-available/sqlsrv.ini"
        phpenmod -v "$version" sqlsrv
      fi
    fi
  done
}

install_pdo_sqlsrv() {
  # Supports php =>7.0
  for version in "7.0" "7.1" "7.2" "7.3"
  do
    if [[ $(command -v php$version) ]]; then
      if [[ $( pecl list | grep -w pdo_sqlsrv ) ]]; then
        # Already installed, try updating.
        echo "Updating pdo_sqlsrv from pecl..."
        pecl -d php_suffix="$version" upgrade pdo_sqlsrv > /dev/null 2>&1
      else
        # Install PHP drivers for SQL Server using PECL.
        echo "Installing PDO_SQLSRV for PHP $version"
        pecl -d php_suffix="$version" install pdo_sqlsrv > /dev/null 2>&1
        # do not remove files, but register packages as not installed to allow installing for multiple PHP versions
        pecl uninstall -r pdo_sqlsrv > /dev/null 2>&1
        echo "Copying PDO_SQLSRV files for PHP $version"
        cp -f "${DIR}/pdo_sqlsrv.ini" "/etc/php/$version/mods-available/pdo_sqlsrv.ini"
        phpenmod -v "$version" pdo_sqlsrv
      fi
    fi
  done
}

restart_php() {
  echo "Restarting PHP-FPM server"
  for version in "7.0" "7.1" "7.2" "7.3"
  do
    if [[ $(command -v php$version) ]]; then
      service "php$version-fpm" restart > /dev/null 2>&1
    fi
  done
  echo "Restarting Nginx"
  service nginx restart > /dev/null 2>&1
}

echo "Installing SQLSRV and PDO_SQLSRV"
DIR=$(dirname "$0")
install_sqlsrv
install_pdo_sqlsrv
restart_php

echo "SQLSRV and PDO_SQLSRV installed"
