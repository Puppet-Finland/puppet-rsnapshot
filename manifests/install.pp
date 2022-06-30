#
# Class: rsnapshot::install
#
# Install rsnapshot
#
class rsnapshot::install inherits rsnapshot::params {
  package { 'rsnapshot':
    ensure => installed,
    name   => $rsnapshot::params::package_name,
  }
}
