
# Installs SNMP daemon
class snmp::daemon::install {
  include snmp::params

  $ro_user_pw_file = $snmp::params::ro_user_pw_file
  $add_user_script = $snmp::params::add_user_script

  package { 'snmpd':
    ensure => $snmp::daemon::package_status,
    name   => $snmp::params::server_package_name,
  }

  # bind stats script
  file { 'snmpd_named_stats_script':
    path   => '/usr/local/bin/bind_stats.sh',
    source => 'puppet:///modules/snmp/bin/bind_stats.sh',
    mode   => '0550',
    owner  => root,
    group  => 0,
  }

  if $snmp::daemon::create_ro_usm_user {
    # Add a VACM user script
    file { 'add_user_script':
      path   => $add_user_script,
      source => 'puppet:///modules/snmp/bin/add_user_to_snmpd.rb',
      mode   => '0550',
      owner  => root,
      group  => 0,
    }

    # initial user setup
    exec { 'snmpd initial user setup':
      command => $add_user_script,
      require => [File['add_user_script'], Package['snmpd']],
      unless  => "test -f ${ro_user_pw_file}",
      path    => '/bin:/usr/bin'
    }
  }
}