#
define jboss::bind_address::inet_address (
  $jboss_config = undef,
  $address      = undef,
) {

  if (!is_domain_name($address)) {
    fail("${address} is not a valid domain name, or ip address")
  }

  $inet_path = "//interfaces/interface[#attribute/name='${title}']/inet-address/#attribute/value"

  augeas { $title:
    incl    => $jboss_config,
    lens    => 'Xml.lns',
    notify  => Service[jboss],
    changes => "set ${inet_path} '${address}'",
    require => Class[Jboss],
  }
}
