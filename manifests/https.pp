#
define jboss::https(
  $key_alias            = undef,
  $password             = undef,
  $certificate_key_file = undef,
  $config_file          = undef,
) {
  $non_valid_augeas_xml = '"<?xml version=\'1.0\' encoding=\'UTF-8\'?>"'
  $https_connector = 'server/profile/subsystem[22]/connector[2]'
  $https = "${https_connector}/#attribute"
  $ssl = "${https_connector}/ssl/#attribute"

  if (!$password) {
    fail(':password parameter must be provided')
  }

  if (!$certificate_key_file) {
    fail(':certificate_key_file parameter must be provided')
  }

  if (!$config_file) {
    fail(':config_file parameter must be provided')
  }

  # Workaround: Augeas Xml.lens does not support
  # single quotes in XML files.
  #
  # Also the xml header declaration leads augeas
  # to fail (<?xml version='1.0' encoding='UTF-8'?>).
  #
  # This make sure the xml header is not present in
  # the file by the time augeas runs.
  exec { "[${title}] filter standalone.xml":
    command => "/bin/sed -i 1d ${config_file}",
    onlyif  => "/bin/grep -Fxq ${non_valid_augeas_xml} ${config_file}",
  }
  ->
  augeas { "[${title}] config":
    incl    => $config_file,
    lens    => 'Xml.lns',
    changes => [
      "set ${https}/name               'https'",
      "set ${https}/protocol           'HTTP/1.1'",
      "set ${https}/scheme             'HTTPS'",
      "set ${https}/socket-binding     'https'",
      "set ${https}/enable-lookups     'false'",
      "set ${https}/secure             'true'",
      "set ${ssl}/name                 'ssl'",
      "set ${ssl}/password             '${password}'",
      "set ${ssl}/certificate-key-file '${certificate_key_file}'",
      "set ${ssl}/protocol             'TLSv1'",
      "set ${ssl}/verify-client        'false'",
    ],
    notify  => Service['jboss'],
  }
}
