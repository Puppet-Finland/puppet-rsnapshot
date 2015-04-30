#
# == Class: rsnapshot::params
#
# Defines some variables based on the operating system
#
class rsnapshot::params {

    include ::os::params

    case $::osfamily {
        'Debian': {
            $package_name = 'rsnapshot'
        }
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }
}
