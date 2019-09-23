#!/usr/bin/env bash
DIR=`dirname $0`

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

    echo " * Checking Apt Keys"
    if [[ ! $( apt-key list | grep 'Microsoft' ) ]]; then
      # Apply the Microsoft ODBC signing key
      echo "Applying Microsoft signing key..."
      apt-key add "${DIR}/msodbcsql17.pgp.key"
    fi

    # Add the MS SQL Drivers to the apt sources.
    echo " * Copying Microsoft ODBC Driver source"
    cp -f "${DIR}/apt-source-msodbcsql.list" /etc/apt/sources.list.d/msodbcsql-sources.list

    # Update all of the package references before installing anything
    echo "Running apt-get update..."
    apt-get -y update

    # Install required packages
    echo "By installing this package you agree with the MS ODBC Drivers EULA"
    echo "Installing msodbcsql17 apt-get packages..."
    if ! ACCEPT_EULA=Y apt-get -y install msodbcsql17; then
      echo "Installing msodbcsql17 apt-get package returned a failure code, cleaning up apt caches then exiting"
      apt-get clean
      return 1
    fi
  else
    pkg_version=$(dpkg -s "msodbcsql17" 2>&1 | grep 'Version:' | cut -d " " -f 2)
    print_pkg_info "msodbcsql17" "$pkg_version"
  fi

  return 0
}

clean() {
    # Remove unnecessary packages
    echo "Removing unnecessary packages..."
    apt-get autoremove -y

    # Clean up apt caches
    apt-get clean
}

unixodbc_install
msodbcsql_install
clean
