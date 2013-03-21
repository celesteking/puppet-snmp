# VACM com2sec line
define snmp::daemon::acl::com2sec(
  $secname = $title,
  $source = 'default',
  $community,
  $comment = false,
  $order = 12,
){
  # com2sec secname source community
  $line = "com2sec\t${secname}\t${source}\t${community}\n"

  if $comment {
    $content = concat("# ${comment}", "\n", $line)
  } else {
    $content = $line
  }

  concat::fragment { "snmpd_vacm: com2sec-${secname}":
    target  => 'snmpd.conf',
    content => $content,
    order => $order,
  }
}