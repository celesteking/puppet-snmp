
class snmp::daemon::acl::defaults {
  snmp::daemon::acl::view { 'all':
    type    => 'included',
    oid     => '.1',
    comment => 'Define all view that contains everything',
  }

  snmp::daemon::acl::group { 'default:fullro':
    group   => 'fullro',
    model   => 'usm',
    secname => 'reader',
    comment => 'Assign reader user to fullro group'
  }

  snmp::daemon::acl::access { 'default:fullro':
    group   => 'fullro',
    level   => 'auth',
    read    => 'all',
    comment => 'Grant fullro group full RO access to all view'
  }

}