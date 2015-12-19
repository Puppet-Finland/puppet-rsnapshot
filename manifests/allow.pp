#
# == Class: rsnapshot::allow
#
# Allow access from the host running snapshot. This class can be converted into 
# a define when/if there are several hosts fetching data from a single node.
#
class rsnapshot::allow
(
    $host,
    $key,
    $key_type = 'rsa',
    $ensure = 'present',
    $user = 'root'
)
{
    ssh_authorized_key { "rsnapshot-${user}":
        ensure  => $ensure,
        name    => "${user}@${host}",
        key     => $key,
        type    => $key_type,
        user    => $user,
        options => "from=\"${host}\"",
    }

}
