#
# @summary
#   Setup SSH (keys) for rsnapshot
#
# @param private_key_content
# @param user
#
class rsnapshot::config::ssh (
  String $private_key_content,
  String $user = 'root',
) {
  $home = $user ? {
    'root'  => '/root',
    default => "/home/${user}",
  }

  file { "${home}/.ssh":
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { 'rsnapshot-private-ssh-key':
    ensure  => file,
    name    => "${home}/.ssh/rsnapshot-private-ssh-key",
    content => $private_key_content,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => File["${home}/.ssh"],
  }
}
