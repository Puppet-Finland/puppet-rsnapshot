#
# @summary
#   Allow access from the host running snapshot. Technically this is in no way
#   related to rsnapshot, as it just installs an authorized key.
# @param host
#   Hostname or IP of the rsnapshot server
# @param key
#   Key content (without key type or comment)
# @param key_type
#   Key type
# @param ensure
#   Status of this allow
# @param user
#
class rsnapshot::allow (
  Stdlib::Host                                                $host,
  String                                                      $key,
  Enum['dsa','ecdsa','ecdsa-sk','ed25519','ed25519-sk','rsa'] $key_type = 'rsa',
  Enum['present','absent']                                    $ensure = 'present',
  String                                                      $user = 'root',

) {
  ssh_authorized_key { "rsnapshot-${user}":
    ensure  => $ensure,
    name    => "${user}@${host}",
    key     => $key,
    type    => $key_type,
    user    => $user,
    options => "from=\"${host}\"",
  }
}
