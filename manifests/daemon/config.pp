
# Configures SNMP daemon
class snmp::daemon::config {
  include snmp::params
  include snmp::daemon::acl::defaults

  $server_role = $snmp::daemon::role

  # locally supplied config path
  $vacm_user_file = $snmp::params::vacm_user_file

  tfile { 'snmpd.init.config':
    mode      => '0644',
    owner     => 'root',
    group     => 0,
    path      => $snmp::params::sysconfig,
    source    => 'snmpd.init.config',
    classname => $server_role,
  }

  concat { 'snmpd.conf':
    path  => $snmp::params::server_config,
    mode  => 0640,
    owner => root,
    group => 0,
  }

  concat::fragment { 'snmpd_main_part':
    target  => 'snmpd.conf',
    content => template(get_template_path('snmpd.conf', 'snmp', $server_role)),
    order   => 01,
  }

  concat::fragment { 'snmpd_vacm_part':
    target  => 'snmpd.conf',
    content => template(get_template_path('snmpd.vacm.conf', 'snmp', $server_role)),
    order   => 10,
  }

  # locally supplied config
  concat::fragment { 'snmpd_vacm_users_part':
    target => 'snmpd.conf',
    ensure => $vacm_user_file,
    order  => 15,
  }

  concat::fragment { 'snmpd_commands_part':
    target  => 'snmpd.conf',
    content => template(get_template_path('snmpd.exec.conf', 'snmp', $server_role)),
    order   => 20,
  }

}