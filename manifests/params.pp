#
# @summary
#   Defines some variables based on the operating system
#
class rsnapshot::params {

  case $facts['os']['family'] {
    'Debian': {
      $package_name = 'rsnapshot'
    }
    default: {
      fail("Unsupported OS: ${facts['os']['family']}")
    }
  }
}
