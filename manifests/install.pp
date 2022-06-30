#
# @summary
#   Install rsnapshot
#
class rsnapshot::install {
  package { 'rsnapshot':
    ensure => installed,
  }
}
