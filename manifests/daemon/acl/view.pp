# VACM view line
define snmp::daemon::acl::view(
  $view = $title,
  $type = 'included',
  $oid,
  $mask = false,
  $comment = false,
  $order = 11,
){
  # view name incl/excl subtree mask(optional)
  $line_pre = "view\t${view}\t${type}\t${oid}"

  if $mask {
    $line = "${line_pre}\t${mask}\n"
  } else {
    $line = "${line_pre}\n"
  }

  if $comment {
    $content = concat("# ${comment}", "\n", $line)
  } else {
    $content = $line
  }

  concat::fragment { "snmpd_vacm: view-${view}":
    target  => 'snmpd.conf',
    content => $content,
    order   => $order,
  }
}