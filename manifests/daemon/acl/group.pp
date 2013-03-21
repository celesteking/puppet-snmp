# VACM group line
define snmp::daemon::acl::group(
  $group = $title,
  $model = 'usm',
  $secname,
  $comment = false,
  $order = 13,
){
  # group name model secname
  $line = "group\t${group}\t${model}\t${secname}\n"
  $uniq = regsubst($line, '[\t\n\s]+', '-', 'G')

  if $comment {
    $content = concat("# ${comment}", "\n", $line)
  } else {
    $content = $line
  }

  concat::fragment { "snmpd_vacm: ${uniq}":
    target  => 'snmpd.conf',
    content => $content,
    order   => $order,
  }
}