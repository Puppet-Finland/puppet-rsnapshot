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
# [*snapshot_root*]
#   The directory where backups are placed. Defaults to '/var/backups/rsnapshot'.
# [*excludes*]
#   An array of paths to exclude. Defaults to [ '/tmp', '/media', '/mnt', 
# '/proc', '/sys']. Define as [] to exclude nothing.
# [*backups*]
#   An array containing _tab-separated_ strings containing the backup source and 
#   the backup destination. No default value. See the Examples section for an 
#   example.
#
# == Examples
#
# class { 'rsnapshot':
#   snapshot_root => '/var/rsnapshot',
#   excludes => [],
#   backups => ['/etc/						localhost/',
#               'root@server.domain.com		server/'],
# }
#
# == Authors
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-lisence
# See file LICENSE for details
#
class rsnapshot
(
    $snapshot_root = '/var/backups/rsnapshot',
    $excludes = ['/tmp', '/media', '/mnt', '/proc', '/sys'],
    $backups = ['']
)
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_rsnapshot') != 'false' {

    include rsnapshot::install

    class { 'rsnapshot::config':
        snapshot_root => $snapshot_root,
        excludes => $excludes,
        backups => $backups,
    }
}
}
