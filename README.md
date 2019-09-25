# VVV ODBC Utility

## Overview

A utility to install Microsoft ODBC drivers and PHP modules for Microsoft SQL Server as part of provisioning in [VVV](https://varyingvagrantvagrants.org/).

## Description

This package hooks into the VVV utilities system to install the Microsoft ODBC driver for Ubuntu 18.04 and the PHP modules for Microsoft SQL Server at the system level. It will install the appropriate PHP modules for all versions of PHP => 7.0 active in the VVV core utilities section (in addition to the default PHP version).

**System requirements warning**: This utility requires VVV 3.0 or greater. At present it needs least Ubuntu 16.04 LTS (Xenial) to work correctly (due to problems encountered with the Microsoft drivers and `unixodbc` package on Ubunut < 16.04). VVV prior to version 3.0 installed Ubuntu 14.04 LTS (Trusty) but since 3.0 uses 18.04 (Bionic).

## Installation

Installation happens automatically during site provisioning. Add the following to your `vvv-custom.yml` configuration file and then reprovision (`vagrant up --provision` or `vagrant reload --provision`).

```yml
utilities:
  odbc:
    - msodbcsql17 # MS SQL server ODBC libraries
    - sqlsrv # MS SQL PHP drivers
utility-sources:
  odbc: https://github.com/admturner/vvv-odbc-utilities.git
```

Your final "utilities" list may look something like this:

```yml
utilities:
  core: # The core VVV utility
    - php73
    - memcached-admin # Object cache management
    - opcache-status # opcache management
    - phpmyadmin # Web based database client
    - webgrind # PHP Debugging
    - tls-ca # SSL/TLS certificates
    - mongodb # needed for Tideways/XHGui
    - tideways # PHP profiling tool

  odbc:
    - msodbcsql17 # MS SQL server ODBC libraries
    - sqlsrv # PHP SQL server extensions

utility-sources:
  odbc: https://github.com/admturner/vvv-odbc-utilities.git
```

This configuration would install the default VVV PHP version (currently 7.2) as well as PHP 7.3. VVV ODBC Utility would then install the Microsoft ODBC Driver 17 and dependencies and would then install and configure the `sqlsrv` and `pdo_sqlsrv` PHP modules for PHP 7.2 and 7.3.

For more see the [official VVV documentation on utilities](https://varyingvagrantvagrants.org/docs/en-US/utilities/).

## APT packages this installs

- `unixodbc-dev` (ODBC libraries for UNIX, development files)
- `msodbcsql17` (Microsoft ODBC Driver 17 for SQL Server)

*Installing the above will also install dependencies.*

## PHP Drivers this installs

- `sqlsrv` [PHP SQLSRV extension](https://php.net/manual/en/book.sqlsrv.php)
- `pdo_sqlsrv` [PHP PDO_SQLSRV extension](https://php.net/manual/en/ref.pdo-sqlsrv.php)

## References

- [Varying Vagrant Vagrants: Utilities](https://varyingvagrantvagrants.org/docs/en-US/utilities/)
* [Installing the Microsoft ODBC Driver for SQL Server on Linux and macOS](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017) (2018-12-03)
* [Linux and macOS Installation Tutorial for the Microsoft Drivers for PHP for SQL Server](https://docs.microsoft.com/en-us/sql/connect/php/installation-tutorial-linux-mac?view=sql-server-2017) (2018-07-19)
* [Microsoft/msphpsql repository: Linux and macOS Installation Tutorial](https://github.com/Microsoft/msphpsql/blob/master/Linux-mac-install.md)
