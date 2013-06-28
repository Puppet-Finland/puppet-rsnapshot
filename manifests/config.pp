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
    $backups
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

    # Interestingly, this resource definition has to be virtual, or appending to 
    # the $retain parameter using +> from within rsnapshot::interval does not 
    # work. However, even appending from a class always works. Go figure...
    #
    # This virtual approach ensures that rsnapshot.conf is not realized until 
    # we've included at least one rsnapshot::virtual resource definition.
    @rsnapshot::config::file { 'default-rsnapshot.conf':
        snapshot_root => $snapshot_root,
        excludes => $excludes,
        backups => $backups,
    }
}
