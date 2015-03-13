#called by jboss::config::system_properties
# or could be called externally as well
define jboss::config::property (
  $jboss_config   = undef,
  $pretty_print   = undef,
  $property_value = undef,
) {
  #$property_name = $title


  if $pretty_print {
    $augeas_notify = [Service[jboss],Exec['pretty_print']]
  }
  else {
    $augeas_notify = [Service[jboss]]
  }

  Augeas {
    incl     => $jboss_config,
    notify   => [Service[jboss],Exec['pretty_print']],
    require  => Augeas['system-properties'],
  }

  augeas { $title:
    lens    => 'Xml.lns',
    changes => "set server/system-properties/property[last()+1]/#attribute/name '${title}'",
    onlyif  => "match server/system-properties/property[#attribute/name='${title}'] size == 0",
  }
  ->
  augeas { "$title-value":
    lens    => 'Xml.lns',
    changes => "set server/system-properties/property[#attribute/name='${title}']/#attribute/value '${property_value}'",
    onlyif  => "match server/system-properties/property[#attribute/name='${title}'][#attribute/value='${property_value}'] size == 0',}"
  }
}
