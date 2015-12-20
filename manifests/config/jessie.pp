#
# == Class: rsnapshot::config::jessie
#
# Configurations specific to Debian Jessie
#
# Currently this is only needed to fix this severe Debian bug:
#
# <https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=717451>
#
class rsnapshot::config::jessie inherits rsnapshot::params
{
    file { 'rsnapshot-patch-to-debian-bug-717451':
        ensure => present,
        name   => '/usr/bin/patch-to-debian-bug-717451',
        source => 'puppet:///modules/rsnapshot/patch-to-debian-bug-717451',
        owner  => root,
        group  => root,
        mode   => '0644',
    }

    exec { 'rsnapshot-patch-debian-bug-717451':
        command => 'patch -p0 ./rsnapshot < ./patch-to-debian-bug-717451',
        onlyif  => 'patch --dry-run -f -p0 ./rsnapshot < ./patch-to-debian-bug-717451',
        path    => ['/bin/', '/usr/bin'],
        cwd     => '/usr/bin',
    }
}
