
# Configures SNMP daemon service
class snmp::daemon::service {
  include snmp::params

  service { 'snmpd':
    ensure     => $snmp::daemon::package_status ? {
      absent  => 'stopped',
      default => $snmp::daemon::service_ensure,
    },
    name       => $snmp::params::server_service_name,
    enable     => $snmp::daemon::service_enable,
    hasstatus  => $snmp::params::server_service_hasstatus,
    hasrestart => $snmp::params::server_service_hasrestart,
  }

}