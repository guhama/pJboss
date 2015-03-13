#
define jboss::datasource(
  $url                = undef,
  $username           = undef,
  $password           = undef,
  $jndi_name          = undef,
  $deploy_folder      = undef,
  $jta                = false,
  $pool_name          = 'default-db-pool',
  $driver_class       = 'oracle.jdbc.OracleDriver',
  $driver             = 'ojdbc6-11.2.0.2.0.jar',
  $new_connection_sql = 'select 1 from dual',
  $owner              = 'jboss',
  $group              = 'jboss',
  $pool_options       = undef,
) {
  $datasource_name = $title

  if (!$url) {
    fail(':url parameter must be provided')
  }

  if (!$username) {
    fail(':username parameter must be provided')
  }

  if (!$password) {
    fail(':password parameter must be provided')
  }

  if (!$jndi_name) {
    fail(':jndi_name parameter must be provided')
  }

  if (!$deploy_folder) {
    fail(':deploy_folder parameter must be provided')
  }

  file { "${deploy_folder}/${datasource_name}-ds.xml":
    ensure  => present,
    content => template('jboss/datasource/template-ds.xml.erb'),
    owner   => $owner,
    group   => $group,
    notify  => Service['jboss'],
  }
}
