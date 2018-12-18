#!/usr/bin/env bash

### FUNCTIONS

network_detection() {
  # Network Detection
  #
  # Make an HTTP request to google.com to determine if outside access is available
  # to us. If 3 attempts with a timeout of 5 seconds are not successful, then we'll
  # skip a few things further in provisioning rather than create a bunch of errors.
  if [[ "$(wget --tries=3 --timeout=5 --spider --recursive --level=2 http://google.com 2>&1 | grep 'connected')" ]]; then
    echo "Network connection detected..."
    ping_result="Connected"
  else
    echo "Network connection not detected. Unable to reach google.com..."
    ping_result="Not Connected"
  fi
}

network_check() {
  network_detection
  if [[ ! "$ping_result" == "Connected" ]]; then
    echo -e "\nNo network connection available, skipping package installation"
    exit 0
  fi
}

not_installed() {
  dpkg -s "$1" 2>&1 | grep -q 'Version:'
  if [[ "$?" -eq 0 ]]; then
    apt-cache policy "$1" | grep 'Installed: (none)'
    return "$?"
  else
    return 0
  fi
}

print_pkg_info() {
  local pkg="$1"
  local pkg_version="$2"
  local space_count
  local pack_space_count
  local real_space

  space_count="$(( 20 - ${#pkg} ))" #11
  pack_space_count="$(( 30 - ${#pkg_version} ))"
  real_space="$(( space_count + pack_space_count + ${#pkg_version} ))"
  printf " * $pkg %${real_space}.${#pkg_version}s ${pkg_version}\n"
}

unixodbc_install() {
  local pkg_version

  if not_installed "unixodbc-dev"; then
    echo " * unixodbc-dev [not installed]"
    echo "Installing unixodbc-dev apt-get packages..."
    apt-get -y install unixodbc-dev
  else
    echo "Required packages already installed:"
    pkg_version=$(dpkg -s "unixodbc-dev" 2>&1 | grep 'Version:' | cut -d " " -f 2)
    print_pkg_info "unixodbc-dev" "$pkg_version"
  fi
}

msodbcsql_install() {
  local pkg_version

  if not_installed "msodbcsql17"; then
    echo " * msodbcsql17 [not installed]"

    # Apply the MS ODBC signing key
    wget --quiet https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -

    # Add the MS SQL Drivers to the apt sources.
    wget --quiet https://packages.microsoft.com/config/ubuntu/16.04/prod.list -O- > /etc/apt/sources.list.d/mssql-release.list

    # Update all of the package references before installing anything
    echo "Running apt-get update..."
    apt-get -y update

    # Install required packages
    echo "By installing this package you agree with the MS ODBC Drivers EULA"
    echo "Installing msodbcsql17 apt-get packages..."
    ACCEPT_EULA=Y apt-get install msodbcsql17
  else
    pkg_version=$(dpkg -s "msodbcsql17" 2>&1 | grep 'Version:' | cut -d " " -f 2)
    print_pkg_info "msodbcsql17" "$pkg_version"
  fi
}

clean() {
    # Remove unnecessary packages
    echo "Removing unnecessary packages..."
    apt-get autoremove -y

    # Clean up apt caches
    apt-get clean
}

network_check
unixodbc_install
msodbcsql_install
clean
