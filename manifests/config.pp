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

) inherits rsnapshot::params
{

    # Ensure the backup root directory is present
    file { 'rsnapshot-snapshot-root':
        ensure => directory,
        name   => $snapshot_root,
        owner  => $::os::params::adminuser,
        group  => $::os::params::admingroup,
        mode   => '0755',
    }

    file { 'rsnapshot.conf':
        ensure  => present,
        name    => '/etc/rsnapshot.conf',
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        content => template('rsnapshot/rsnapshot.conf.erb'),
        require => File['rsnapshot-snapshot-root'],
    }
}
