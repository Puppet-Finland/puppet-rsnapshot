#
# Class: rsnapshot::install
#
# Install rsnapshot
#
class rsnapshot::install {

    package { 'rsnapshot':
        ensure => installed,
    }
}
