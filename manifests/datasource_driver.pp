#
define jboss::datasource_driver(
  $url        = undef,
  $deploy_dir = undef,
  $user       = 'root',
) {
  if (!$url) {
    fail(':url parameter must be provided')
  }

  if (!$deploy_dir) {
    fail(':deploy_dir parameter must be provided')
  }

  wget::fetch { $url:
    destination => "${deploy_dir}/${name}",
    timeout     => 0,
    verbose     => false,
    execuser    => $user,
  }
}
