# Class assumes hiera configuration like so
#system_properties:
#  oozie:
#    property_value: 'value'
#  securityServiceUrl:
#    property_value: 'value2'

# pretty print varable will call a command line tool to format
# the xml if true
class jboss::config::system_properties(
  $jboss_config  = hiera('jboss_config', '/opt/app/jboss/jboss/standalone/configuration/standalone.xml'),
  $pretty_print  = true,
){
  $defaults = {
    'jboss_config' => $jboss_config,
  }

  exec { "[${title}] filter standalone.xml":
    command => "/bin/sed -i 1d ${config_file}",
    onlyif  => "/bin/grep -Fxq ${non_valid_augeas_xml} ${config_file}",
  }

  augeas { "system-properties":
    lens    => 'Xml.lns',
    incl    => $jboss_config,
    changes => 'ins system-properties after server/extensions',
    onlyif  => 'match server/system-properties size == 0',
    require => [Class[Jboss],Exec["[${title}] filter standalone.xml"]],
    notify  => [Service[jboss],Exec['pretty_print']],
  }

  create_resources(jboss::config::property, hiera_hash('system_properties'),$defaults)


  exec { 'pretty_print':
    command     => "/usr/bin/xmllint --format --output $jboss_config $jboss_config",
    refreshonly => true,
  }
}
