#
class jboss::service {
  $user           = $jboss::user
  $group          = $jboss::group
  $java_opts      = $jboss::java_opts
  $java_home      = $jboss::java_home
  $pid_path       = $jboss::pid_path
  $log_path       = $jboss::log_path
  $bind_address   = $jboss::bind_address
  $enable_service = $jboss::enable_service
  $jboss_home     = "${jboss::install_path}/${jboss::install_dir}"

  file { [$pid_path, $log_path]:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    require => Class['jboss::install'],
  }

  file { '/etc/init.d/jboss':
    ensure  => file,
    content => template('jboss/etc/init.d/jboss.sh.erb'),
    mode    => '0755',
    notify  => Service['jboss'],
    require => [File[$pid_path], File[$log_path]],
  }

  service { 'jboss':
    ensure     => running,
    enable     => $enable_service,
    hasrestart => true,
    require    => File['/etc/init.d/jboss'],
  }
}
