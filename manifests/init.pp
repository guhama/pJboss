#
class jboss(
  $source_path    = undef,
  $source_file    = undef,
  $install_dir    = undef,
  $user_home_dir  = undef,
  $java_home      = '/usr',
  $install_path   = '/opt/app',
  $user           = 'jboss',
  $group          = 'jboss',
  $user_password  = hiera('jboss_password','$1$szJMjirc$GreoKE6hluP4ZBqkyPfV5.'),
  $bind_address   = $::fqdn,
  $enable_service = true,
  $java_opts      = '',
  $pid_path       = '/var/run/jboss',
  $log_path       = '/opt/app/jboss/jboss/logs',
  $sym_link       = undef,
) {
  if (!$jboss::source_path) {
    fail('"source_path" parameter must be provided')
  }

  if (!$jboss::source_file) {
    fail('"source_file" parameter must be provided')
  }

  if (!$jboss::install_dir) {
    fail('"install_dir" parameter must be provided')
  }

  # TODO implement function to encapsulate this logic
  $user_home = empty($user_home_dir) ? {
    true    => "/export/home/${user}",
    default => $user_home_dir,
  }

  include jboss::dependencies
  include jboss::install
  include jboss::service
}
