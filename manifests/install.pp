#
class jboss::install {
  $user          = $jboss::user
  $user_home     = $jboss::user_home
  $user_password = $jboss::user_password
  $group         = $jboss::group
  $install_dir   = $jboss::install_dir
  $install_path  = $jboss::install_path
  $source        = "${jboss::source_path}/${jboss::source_file}"
  $sym_link      = $jboss::sym_link

  if !defined(Group[$group]) {
    group { $group:
      ensure     => present,
      gid        => 1506,
      forcelocal => true,
    }
  }

  if !defined(User[$user]) {
    user { $user:
      ensure   => present,
      uid      => 1506,
      gid      => $group,
      home     => $user_home,
      password => $user_password,
      forcelocal => true,
      require  => Group[$group],
    }
  }

  file { "${install_path}":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    notify  => Exec['unzip file'],
  }

  exec { 'unzip file':
    command => "/usr/bin/unzip -d ${install_path} ${source}",
    creates => "${install_path}/${install_dir}",
    user    => $user,
    group   => $group,
    require => [
      Package['unzip'],
      User[$user],
    ],
  }

  if ($sym_link) {
    file { 'jboss_symlink':
      ensure   => link,
      target   => "${install_path}/${install_dir}",
      path     => $sym_link,
      owner    => $user,
      group    => $group,
      #require => File["${install_path}/${install_dir}"],
      require  => Exec['unzip file'],
    }
  }

  file { "${install_path}/${install_dir}/welcome-content/index.html":
    ensure  => file,
    owner   => $user,
    group   => $group,
    force   => true,
    source  => "${install_path}/${install_dir}/welcome-content/index_noconsole.html",
    require => Exec['unzip file'],
    before  => Service['jboss'],
  }
}
