# == Class: snmp::params
#
# This class handles OS-specific configuration of the snmp module and supplies defaults.
#
class snmp::params {

  $ro_community = false
  $ro_networks  = '127.0.0.1'
  $contact      = 'Unknown'
  $location     = 'Unknown'

  $open_oids = [ '.iso.org.dod.internet.mgmt.mib-2.system.sysContact.0', '.iso.org.dod.internet.mgmt.mib-2.host.hrSystem.hrSystemUptime.0', ]
  $system_view_oids = ['.1.3.6.1.2.1.1', '.1.3.6.1.2.1.25.1.1']

  $accesses     = [
    'access  notConfigGroup ""      any       noauth    exact  systemview none none',
  ]

  $majdistrelease = regsubst($::operatingsystemrelease,'^(\d+)\.(\d+)','\1')

  $config_dir = '/etc/snmp'

  $client_config       = "${config_dir}/snmp.conf"

  $server_service_name = 'snmpd'
  $server_service_hasstatus = true
  $server_service_hasrestart = true

  $trap_service_config = "${config_dir}/snmptrapd.conf"
  $trap_service_name   = 'snmptrapd'

  $add_user_script = '/usr/local/bin/add_user_to_snmpd.rb'
  $ro_user_pw_file = "${config_dir}/reader.pw"
  $vacm_user_file = "${config_dir}/snmpd.vacm.users.conf"

  case $::osfamily {
    RedHat: {
      if $::operatingsystem == 'Fedora' {
        fail("Module snmp is not supported on ${::operatingsystem}")
      }

      $server_package_name = 'net-snmp'

      $server_config      = "${config_dir}/snmpd.conf"
      if $::lsbmajdistrelease <= '5' {
        $sysconfig         = '/etc/sysconfig/snmpd.options'
        $var_net_snmp      = '/var/net-snmp'
        $varnetsnmp_perms  = '0700'

        $server_init_options = 'OPTIONS="-LS4d -Lf /dev/null -p /var/run/snmpd.pid -a"'
      } else {
        $sysconfig         = '/etc/sysconfig/snmpd'
        $var_net_snmp      = '/var/lib/net-snmp'
        $varnetsnmp_perms  = '0755'

        $server_init_options = '# OPTIONS="-LS0-6d -Lf /dev/null -p /var/run/snmpd.pid"'
      }

      $client_package_name = 'net-snmp-utils'

      if $::lsbmajdistrelease <= '5' {
        $trap_sysconfig    = '/etc/sysconfig/snmptrapd.options'
      } else {
        $trap_sysconfig    = '/etc/sysconfig/snmptrapd'
      }
    }
    Debian: {
      $server_package_name = 'snmpd'
      $server_config       = "${config_dir}/snmpd.conf"
      $server_init_options = ''

      $sysconfig           = '/etc/default/snmp'
      $var_net_snmp        = '/var/lib/snmp'
      $varnetsnmp_perms    = '0700'

      $client_package_name = 'snmp'

    }
    default: {
      fail("Module snmp is not supported on ${::operatingsystem}")
    }
  }
}
