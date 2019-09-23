#!/usr/bin/env bash
# PHP SQLSVR and PDO_SQLSRV extensions
DIR=`dirname $0`

install_sqlsrv() {
  echo -e "Updating pecl channel"
  pecl channel-update pecl.php.net

  if [[ $( pecl list | grep -w sqlsrv ) ]]; then
    # Already installed, try updating.
    echo "Updating sqlsrv from pecl..."
    pecl upgrade sqlsrv
  else
    # Install PHP drivers for SQL Server using PECL.
    echo "Installing sqlsrv from pecl..."
    pecl install sqlsrv
  fi

  if [[ $( pecl list | grep -w pdo_sqlsrv ) ]]; then
    # Already installed, try updating.
    echo "Updating pdo_sqlsrv from pecl..."
    pecl upgrade pdo_sqlsrv
  else
    # Install PHP drivers for PDO SQL Server using PECL.
    echo "Installing pdo_sqlsrv from pecl..."
    pecl install pdo_sqlsrv
  fi
}

configure_sqlsrv() {
  echo "Configuring sqlsrv and pdo_sqlsrv for PHP $version"
  # Supports php =>7.0
  for version in "7.0" "7.1" "7.2" "7.3"
  do
    if [[ $(command -v php$version) ]]; then
      echo "Copying sqlsrv and pdo_sqlsrv files for PHP $version"
      cp -f "${DIR}/sqlsrv.ini" "/etc/php/$version/mods-available/sqlsrv.ini"
      cp -f "${DIR}/pdo_sqlsrv.ini" "/etc/php/$version/mods-available/pdo_sqlsrv.ini"
    fi
    phpenmod -v "$version" sqlsrv
    phpenmod -v "$version" pdo_sqlsrv
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

echo "Installing SQLSVR and PDO_SQLSRV"
DIR=$(dirname "$0")
install_sqlsrv
configure_sqlsrv
restart_php

echo "SQLSVR and PDO_SQLSRV installed"
