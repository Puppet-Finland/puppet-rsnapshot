#
# == Class: rsnapshot::config
#
# Class that configures rsnapshot. The actual configuration file is managed by a 
# define; this allows us to use rsnapshot::interval define to configure not only 
# cron, but also the backup retaining periods in rsnapshot.conf.
#
class rsnapshot::config
(
    $snapshot_root,
    $excludes,
    $backups,
    $retains
)
{

    # Ensure the backup root directory is present
    file { 'rsnapshot-snapshot-root':
        name => $snapshot_root,
        ensure => directory,
        owner => root,
        group => root,
        mode => 755,
    }

    file { 'rsnapshot.conf':
        ensure => present,
        name => '/etc/rsnapshot.conf',
        owner => root,
        group => root,
        mode => 644,
        content => template('rsnapshot/rsnapshot.conf.erb'),
        require => File['rsnapshot-snapshot-root'],
    }
}
