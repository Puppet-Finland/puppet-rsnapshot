# rsnapshot

A Puppet module for managing rsnapshot

# Module usage

Using this module from Hiera is fairly straightforward:

    classes:
        - rsnapshot

    rsnapshot::snapshot_root: '/backup/rsnapshot'
    rsnapshot::backups:
        - '/etc/': 'backup.domain.com/'
        - '/var/backups/local/': 'backup.domain.com/'
        - 'root@server.domain.com:/etc/': 'server.domain.com/'
    rsnapshot::retains:
        - daily: 7
        - weekly: 4
        - monthly: 6
    rsnapshot::crons:
        daily:
            minute: 0
            hour: 10
        weekly:
            minute: 0
            hour: 12
            weekday: 3
        monthly:
            minute: 0
            hour: 14
            monthday: 1

Note that the titles of the rsnapshot::cron resources need to match those given 
for retains in the main class - here "daily", "weekly" and "monthly". Also note 
that the "retain" parameters _need_ to be determined in the correct order, or 
rsnapshot will start "eating" its own backups; the more frequent backups (e.g. 
"daily") should be defined earlier than and also run before the less frequent 
ones (e.g. "monthly). Aping the above configuration is probably the safest bet.

For more details on module usage refer to these source files:

* [Class: rsnapshot](manifests/init.pp)
* [Define: rsnapshot::cron](manifests/cron.pp)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Debian 7 and 8

Other *NIX-like operating systems should work out of the box or with small 
modifications.
