define rsnapshot::config::file
(
    $snapshot_root,
    $retains = [],
    $excludes,
    $backups
)
{

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
