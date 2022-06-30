#
# @summary
#   Setup SSH (keys) for rsnapshot
#
#   Currently the key names are hardcoded and the keys have to be present on the
#   Puppet fileserver. The nodes being backed up needs to have the public key in
#   /root/.ssh/authorized_keys; this is handled automatically in the
#   ::rsnapshot::allow class.
#
# @param private_key_content
#
class rsnapshot::config::ssh (
  String $private_key_content

) inherits rsnapshot::params {
  file { 'rsnapshot-private-ssh-key':
    ensure  => file,
    name    => '/root/.ssh/rsnapshot-private-ssh-key',
    content => $private_key_content,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }
}
