#
# == Class: rsnapshot
#
# Class for managing snapshot backup configuration. Schedules and retaining 
# periods are handled by the rsnapshot::interval define.
#
# NOTE: This class not yet handle distribution of the backup server's SSH keys.
#
# == Parameters
#
# [*manage*]
#   Whether to manage rsnapshot with Puppet or not. Valid values are true 
#   (default) and false.
# [*snapshot_root*]
#   The directory where backups are placed. Defaults to '/var/backups/rsnapshot'.
# [*excludes*]
#   An array of paths to exclude. Defaults to [ '/tmp', '/media', '/mnt', 
# '/proc', '/sys']. Define as [] to exclude nothing.
# [*backups*]
#   An array containing hashes, where the key is the source (e.g. '/etc/' or 
#   'root@server.domain.com:/var/backups') and the value is the target (e.g. 
#   'localhost/' or 'server/'.
# [*retains*]
#   Same as $backups, above, but the keys are symbolic names for retain entries 
#   (e.g. 'daily', 'weekly' or 'monthly') and the keys are the number of backups 
#   of that type to retain.
# [*crons*]
#   A hash of rsnapshot::cron resources to to realize.
# [*private_key_content*]
#   The SSH private key to use to connect to the to-be-backed-up nodes.
#
# == Examples
#
# See README.md in the module root directory.
#
# == Authors
#
# Samuli Seppänen <samuli@openvpn.net>
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class rsnapshot
(
    String        $private_key_content,
    Boolean       $manage = true,
    String        $snapshot_root = '/var/backups/rsnapshot',
    Array[String] $excludes = ['/tmp', '/media', '/mnt', '/proc', '/sys'],
    Array         $backups = [],
    Array         $retains = [],
    Hash          $crons = {},
)
{

if $manage {

    include ::rsnapshot::install

    class { '::rsnapshot::config':
        snapshot_root       => $snapshot_root,
        excludes            => $excludes,
        backups             => $backups,
        retains             => $retains,
        private_key_content => $private_key_content,
    }

    create_resources('rsnapshot::cron', $crons)
}
}
