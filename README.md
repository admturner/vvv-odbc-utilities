# VVV ODBC Utility

Utility to install Microsoft ODBC drivers for SQL Server as part of provisioning in [VVV](https://varyingvagrantvagrants.org/).

**System requirements warning**: This utility requires VVV 3.0 or greater. At present it needs least Ubuntu 16.04 LTS (Xenial) to work correctly (due to problems encountered with the < 16.04 Microsoft drivers and `unixodbc` package). VVV prior to version 3.0 installed Ubuntu 14.04 LTS (Trusty).

## How to use

Add the following to your `vvv-custom.yml` configuration file:

```yml
utilities:
  odbc:
    - odbc-mssql17 # MS SQL server ODBC libraries
    - sqlsrv72 # MS SQL PHP 7.2 drivers
utility-sources:
  odbc: https://github.com/admturner/vvv-odbc-utilities.git
```

So that your final "utilities" list may look something like this:

```yml
utilities:
  core: # The core VVV utility
    - memcached-admin # Object cache management
    - opcache-status # opcache management
    - phpmyadmin # Web based database client
    - webgrind # PHP Debugging
    - trusted-hosts # GitHub etc
    - tls-ca # SSL
  odbc:
    - odbc-mssql17 # MS SQL server ODBC libraries
    - sqlsrv72 # MS SQL PHP 7.2 drivers

utility-sources:
  odbc: https://github.com/admturner/vvv-odbc-utilities.git
```

For more see the [official VVV documentation on utilities](https://varyingvagrantvagrants.org/docs/en-US/utilities/).

## APT packages this installs

- `unixodbc-dev` (ODBC libraries for UNIX, development files)
- `msodbcsql17` (Microsoft ODBC Driver 17 for SQL Server)

*Installing the above will also install dependencies.*

## PHP Drivers this installs

- `sqlsrv` [PHP SQLSVR extension](https://php.net/manual/en/book.sqlsrv.php)
- `pdo_sqlsrv` [PHP PDO_SQLSRV extension](https://php.net/manual/en/ref.pdo-sqlsrv.php) if you want to use PDO.

## Supported versions

**ODBC**

- Ubuntu 18.04 and 18.10.

**SQL SVR**

- PHP 7.0, 7.1, 7.2, and 7.3.

## References

* [Installing the Microsoft ODBC Driver for SQL Server on Linux and macOS](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017) (2018-12-03)
* [Linux and macOS Installation Tutorial for the Microsoft Drivers for PHP for SQL Server](https://docs.microsoft.com/en-us/sql/connect/php/installation-tutorial-linux-mac?view=sql-server-2017) (2018-07-19)
* [Microsoft/msphpsql repository: Linux and macOS Installation Tutorial](https://github.com/Microsoft/msphpsql/blob/master/Linux-mac-install.md)
