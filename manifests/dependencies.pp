#
class jboss::dependencies {
  package { 'unzip':
    ensure => installed,
  }
}
