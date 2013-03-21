# == Class: snmp::daemon
#
# Manages SNMP daemon and associated tools.
#
# === Parameters:
#
# [*ro_community*]
#   Read-only (RO) community string.
#   Default: not set and not configured
#
# [*ro_networks*]
#   Networks that are allowed to RO query the daemon. Accepts an array.
#   Default: 127.0.0.1
#
# [*contact*]
#   Responsible person for the SNMP system.
#   Default: Unknown
#
# [*location*]
#   Location of the SNMP system.
#   Default: Unknown
#
# [*package_status*]
#   Package version, "installed", "latest" or "absent"
#
# [*service_ensure*]
#   Ensure if service is running or stopped.
#   Default: running
#
# [*service_enable*]
#   Start service at boot.
#   Default: true
#
# [*create_ro_usm_user*]
#   Create USM username called `reader` that has access to all OIDs.
#   User's password is stored in `$conf_dir/reader.pw` file and exposed via `snmpd_reader_password` fact
#
# [*open_oids*]
#   String or array of strings describing OIDs to be exposed via snmpd to RO community users.
#
# [*role*]
#   Server role (for custom templates)
#
# === Sample Usage:
#
#   class { 'snmp::daemon':
#     ro_community => 'public',
#   }
#
class snmp::daemon (
  $package_status = 'installed',
  $ro_community       = $snmp::params::ro_community,
  $ro_networks         = $snmp::params::ro_networks,
  $contact            = $snmp::params::contact,
  $location           = $snmp::params::location,
  $create_ro_usm_user = true,
  $accesses           = $snmp::params::accesses,
  $autoupgrade        = false,
  $service_ensure     = 'running',
  $service_enable     = true,
  $service_start_opts = $snmp::params::server_init_options,
  $open_oids  = $snmp::params::open_oids,
  $role       = undef
) inherits snmp::params {
  if ! defined(Class['snmp']) {
    include snmp
  }

  class { 'snmp::daemon::install': }
    ->
  class { 'snmp::daemon::config': }
    ~>
  class { 'snmp::daemon::service': }
    ->
  Class['snmp::daemon']

}
