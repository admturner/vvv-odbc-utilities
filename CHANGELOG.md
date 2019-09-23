# Changelog: VVV ODBC Utility

**Author:** Adam Turner  
**URI:** https://github.com/admturner/vvv-odbc-utilities

This document details all notable changes to the VVV ODBC Utility provisioning package.

<!--
## Major.MinorAddorDeprec.Bugfix (YYYY-MM-DD)

### Todo (for upcoming changes)
### Security (in case of fixed vulnerabilities)
### Fixed (for any bug fixes)
### Changed (for changes in existing functionality)
### Added (for new features)
### Deprecated (for once-stable features removed in upcoming releases)
### Removed (for deprecated features removed in this release)
-->

## 0.5.0-beta.3 (:construction: 2019-09-23)

### Fixed

- :pencil2: Fix more sqlsrv typos...
- Add `-y` flag to `msodbcsql17` apt installation script.

### Changed

- Revise `msodbcsql17` provisioning script to use local apt-source and apt-key files to more closely manage versions and avoid network requests.
- :memo: Update supports section and in Readme to include all PHP => 7 and revise sample `vvv-custom` config to match changes.
- :wrench: Update .editorconfig to align with VVV standards.

### Added

- Local apt-source list and apt-key key for Microsoft ODBC Driver.
- Generic provisioning script and .ini files to install and configure `sqlsrv` and `pdo_sqlsrv` for any active PHP versions from 7.0 to 7.3.
- :wrench: Create a version file.
- :wrench: A .gitattributes file to enforce LF line endings.
- :memo: Create a changelog.

### Removed

- :fire: Delete unneeded PHP-version-specific sqlsrv provision tools.

## 0.4.0 (2019-08-05)

### Changed

- :memo: Update Readme for VVV version 3.0 changes (primarily the switch to using Ubuntu 18.04 LTS Bionic as the base box).

### Added

- Provisioning script and .ini files for sqlsrv and pdo_sqlsrv for PHP 7.3 (`sqlsrv73`).
- :memo: Readme for sqlsrv72 provisioner.
- A `.gitignore` file.

## 0.3.0 (2018-12-17)

### Fixed

- :pencil2: Typo in "sqlsrv."

### Changed

- Switch from echoing a line into php cli and fpm ini files to instead copying those ini files from a local version. Should fix the problem of repeat loading of the php modules due to multiple extension lines being written with each provision.
- Update user messaging.
- :memo: Update Readme with additional resources and examples.

### Added

- Base standalone sqlsrv and pdo_sqlsrv provision script.
- Add a pecl channel-update check at the start of the installation step to update the channel if needed.

## 0.2.0 (2018-12-16)

### Changed

- Create separate provision script functions for MS ODBC driver and the `unixodbc` dependency. They require slightly different installation parameters, so we'll install them separately instead of trying to loop through an array.

## 0.1.0 (2018-12-14)

### Added

- :tada: Initial commit of the base configuration, readme, and in-progress provisioning script.
