# VVV ODBC Utility

Utility to install Microsoft ODBC drivers for SQL Server as part of provisioning in [VVV](https://varyingvagrantvagrants.org/).

**System requirements warning**: At present this seems to require at least Ubuntu 16.04 LTS (Xenial) to work correctly (due to problems encountered with the <16.04 Microsoft drivers and `unixodbc` package). VVV installs Ubuntu 14.04 LTS (Trusty) by default.

:construction: There is an experimental fork of VVV that uses Ubuntu 16.04 instead that you can use with `git clone -b use-ubuntu1604 https://github.com/admturner/VVV.git`, but it is still in development so your mileage may vary.

## How to use

Add the following to your `vvv-custom.yml` configuration file:

```yml
utilities:
  odbc:
    - odbc-mssql17 # MS SQL server ODBC libraries
    - sqlsvr72 # MS SQL PHP 7.2 drivers
utility-sources:
  odbc: https://github.com/admturner/vvv-odbc-utility.git
  branch: master
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
    - sqlsvr72 # MS SQL PHP 7.2 drivers

utility-sources:
  odbc: https://github.com/admturner/vvv-odbc-utility.git
  branch: master
```

For more see the [official VVV documentation on utilities](https://varyingvagrantvagrants.org/docs/en-US/utilities/).

## APT packages this installs

* `unixodbc-dev` (ODBC libraries for UNIX, development files)
* `msodbcsql17` (Microsoft ODBC Driver 17 for SQL Server)

*Installing the above will also install dependencies.*

## PHP Drivers this installs

* `sqlsrv` [PHP SQLSVR extension](https://php.net/manual/en/book.sqlsrv.php)
* `pdo_sqlsrv` [PHP PDO_SQLSRV extension](https://php.net/manual/en/ref.pdo-sqlsrv.php) if you want to use PDO.

## Supported versions

**ODBC**

* `odbc-mssql17`

**SQL SVR**

* `sqlsvr70`
* `sqlsvr72`

## References

* [Installing the Microsoft ODBC Driver for SQL Server on Linux and macOS](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017) (2018-12-03)
