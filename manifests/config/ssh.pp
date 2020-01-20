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
class rsnapshot::config::ssh
(
    String $private_key_content

) inherits rsnapshot::params {

    file { 'rsnapshot-private-ssh-key':
        ensure  => present,
        name    => '/root/.ssh/rsnapshot-private-ssh-key',
        content => $private_key_content,
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0600',
    }
}
