#
# @summary
#   Class for managing snapshot backup configuration. Schedules and retaining 
#   periods are handled by the rsnapshot::interval define.
#
# @param manage
#   Whether to manage rsnapshot with Puppet or not.
# @param snapshot_root
#   The directory where backups are placed.
# @param ssh_args
#   SSH options to use
# @param excludes
#   An array of paths to exclude. Define as [] to exclude nothing.
# @param backups
#   An array containing hashes, where the key is the source (e.g. '/etc/' or 
#   'root@server.domain.com:/var/backups') and the value is the target (e.g. 
#   'localhost/' or 'server/'.
# @param retains
#   Same as $backups, above, but the keys are symbolic names for retain entries 
#   (e.g. 'daily', 'weekly' or 'monthly') and the keys are the number of backups 
#   of that type to retain.
# @param crons
#   A hash of rsnapshot::cron resources to to realize.
# @param private_key_content
#   The SSH private key to use to connect to the to-be-backed-up nodes.
# @param email
#   The default email address to use for cronjobs. Undefined by default,
#   meaning that emails will not be sent or will be sent to the default cron
#   address, whatever that might be. This will only work if some MTA is
#   properly configured on the rsnapshot host.
#
class rsnapshot (
  String           $private_key_content,
  String           $snapshot_root,
  String           $ssh_args = "-p 22",
  Boolean          $manage = true,
  Array[String]    $excludes = ['/tmp', '/media', '/mnt', '/proc', '/sys'],
  Array            $backups = [],
  Array            $retains = [],
  Hash             $crons = {},
  Optional[String] $email = undef,
) {
  if $manage {
    include rsnapshot::install

    class { 'rsnapshot::config':
      snapshot_root       => $snapshot_root,
      ssh_args            => $ssh_args,
      excludes            => $excludes,
      backups             => $backups,
      retains             => $retains,
      private_key_content => $private_key_content,
    }

    create_resources('rsnapshot::cron', $crons)
  }
}
