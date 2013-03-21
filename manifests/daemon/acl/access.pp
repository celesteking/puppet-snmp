# VACM access line
define snmp::daemon::acl::access(
  $group = $title,
  $context = '""',
  $model = 'usm',
  $level = 'auth',
  $match = 'exact',
  $read = 'none',
  $write = 'none',
  $comment = false,
  $order = 14,
){
  # access group context sec.model sec.level  match   read    write   notif
  $line = "access\t${group}\t${context}\t${model}\t${level}\t${match}\t${read}\t${write}\tnone\n"
  $uniq = regsubst($line, '[\t\n\s]+', '-', 'G')

  if $comment {
    $content = concat("# ${comment}", "\n", $line)
  } else {
    $content = $line
  }

  concat::fragment { "snmpd_vacm: ${uniq}":
    target  => 'snmpd.conf',
    content => $content,
    order => $order,
  }
}