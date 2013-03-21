
class snmp::config {
  include snmp::params

  file { $snmp::params::config_dir:
    ensure => directory,
    mode => 755,
    owner => root, group => 0,
  }

  tfile { 'snmp.conf':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    path    => $snmp::params::client_config,
    source  => 'snmp.conf',
  }

  file { 'var-net-snmp':
    ensure  => 'directory',
    mode    => $snmp::params::varnetsnmp_perms,
    owner   => 'root',
    group   => 'root',
    path    => $snmp::params::var_net_snmp,
  }
}