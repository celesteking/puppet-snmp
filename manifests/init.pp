# == Class: snmp
#
# Manages SNMP utility programs (AKA client tools)
#
# === Parameters:
#
# [*package_status*]
#   Package version, "installed", "latest" or "absent"
#
# === Actions:
#
# Installs the SNMP client package and configuration.
#
class snmp (
  $package_status = 'installed',
){
  include snmp::params

  package { 'snmp-client':
    ensure => $package_status,
    name   => $snmp::params::client_package_name,
  }
    ->
  class { 'snmp::config': }
}
