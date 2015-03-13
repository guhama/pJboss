#
define jboss::bind_address::wsdl_host (
  $jboss_config = undef,
  $address      = $title,
) {

  if (!is_domain_name($address)) {
    fail("${address} is not a valid domain name, or ip address")
  }

  $wsdl_host_path = "//subsystem[#attribute/xmlns='urn:jboss:domain:webservices:1.2']/wsdl-host/#text"

  augeas { "wsdl-host ${address}":
    incl    => $jboss_config,
    lens    => 'Xml.lns',
    notify  => Service[jboss],
    changes => "set ${wsdl_host_path} '${address}'",
    require => Class[Jboss],
  }
}
