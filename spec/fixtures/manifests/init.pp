service { 'iptables':
  ensure => stopped,
}
->
package { 'java-1.7.0-openjdk.x86_64':
  ensure => installed,
}
->
class { 'nexus':
  url => 'http://code.premierinc.com/artifacts/'
}
->
nexus::artifact { 'jboss':
  gav        => 'org.jboss:jboss-eap:6.1.0',
  packaging  => 'zip',
  repository => 'platform-tools',
  output     => '/tmp/jboss-eap-6.1.0.zip',
  before     => Class[Jboss::Install],
}
->
class { 'jboss':
  source_path  => '/tmp',
  source_file  => 'jboss-eap-6.1.0.zip',
  install_dir  => 'jboss-eap-6.1',
  java_home    => '/usr',
  java_opts    => '-Xms1303m -Xmx30g',
  install_path => '/opt/jboss',
  sym_link     => '/opt/jboss/jboss',
  bind_address => $::ipaddress,
  user         => 'le_jboss',
  group        => 'jboss_group',
}

$deploy_dir = "${jboss::install_path}/${jboss::install_dir}/standalone/deployments"
$jboss_configuration_dir = "${jboss::install_path}/${jboss::install_dir}/standalone/configuration"
$jboss_config = "${jboss_configuration_dir}/standalone.xml"
$keystore_file = $::keystore

jboss::datasource { 'myapp':
  url           => 'jdbc:host:4321/database',
  password      => 'mysecretpassword',
  username      => 'admin',
  jndi_name     => 'appDatasource',
  driver        => 'ojdbc6g.jar',
  deploy_folder => $deploy_dir,
  require       => Class['jboss'],
}
->
jboss::datasource_driver { 'ojdbc6g.jar':
  url        => 'https://code.premierinc.com/artifacts/service/local/repositories/c3puhibuild1-third-party/content/com/oracle/ojdbc6g/11.2.0.2.0/ojdbc6g-11.2.0.2.0.jar',
  deploy_dir => $deploy_dir,
  user       => 'le_jboss',
  require    => Class['jboss'],
}
->
jboss::https { 'https setup':
  password             => 'BlueMonkey',
  certificate_key_file => $keystore_file,
  config_file          => $jboss_config,
  notify               => Service['jboss'],
  require              => Class['jboss'],
}
