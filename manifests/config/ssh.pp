#
# == Class: rsnapshot::config::ssh
#
# Setup SSH (keys) for rsnapshot
#
# Currently the key names are hardcoded and the keys have to be present on the
# Puppet fileserver. The nodes being backed up needs to have the public key in
# /root/.ssh/authorized_keys; this is handled automatically in the
# ::rsnapshot::allow class.
#
class rsnapshot::config::ssh inherits rsnapshot::params {

    File {
        ensure => present,
        owner  => $::os::params::adminuser,
        group  => $::os::params::admingroup,
        mode   => '0600',
    }

    file { 'rsnapshot-public-ssh-key':
        name   => '/root/.ssh/rsnapshot-public-ssh-key',
        source => 'puppet:///files/rsnapshot-public-ssh-key',
    }

    file { 'rsnapshot-private-ssh-key':
        name   => '/root/.ssh/rsnapshot-private-ssh-key',
        source => 'puppet:///files/rsnapshot-private-ssh-key',
    }
}
