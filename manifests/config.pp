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
    validate_string($snapshot_root)
    validate_array($excludes)
    validate_array($backups)
    validate_array($retains)

    # We need to convert the excludes parameter into actual rsnapshot config 
    # line here, because yaml does not like tabs, and rsnapshot.conf requires 
    # them. The $backups and $retains parameters contain hashes which are
    # processed inside the template.
    $exclude_lines = prefix($excludes, 'exclude	')

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

    # Add SSH keys for rsnapshot
    include ::rsnapshot::config::ssh

    # Patch a bug in rsnapshot in Debian Jessie
    if $::lsbdistcodename == 'jessie' {
        include ::rsnapshot::config::jessie
    }

}
