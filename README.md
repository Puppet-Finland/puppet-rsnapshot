# rsnapshot

A Puppet module for managing rsnapshot.

# Module usage

First you need to create a public/private SSH keypair for rsnapshot, for
example with 'ssh-keygen'. Then add the private and public key to Hiera. Then
you can include the rsnapshot class and give it the parameters you want:

    classes:
        - rsnapshot

    rsnapshot::private_key_content: 'your-private-key'
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

Another example from a Puppet profile:

    $private_key_content = lookup('profile::rsnapshot::private_key_content', String)
    $backups = lookup('profile::rsnapshot::backups')    

    class { '::rsnapshot':
        private_key_content => $private_key_content,
        snapshot_root       => '/var/backups/rsnapshot',
        retains             => [  { 'daily'   => 7 }, { 'weekly'  => 4 }, { 'monthly' => 7 }, ],
        crons               => {  'daily'   => { 'minute' => 30, 'hour' => 6, },
                                  'weekly'  => { 'minute' => 30, 'hour' => 5, 'weekday'  => 6 },
                                  'monthly' => { 'minute' => 30, 'hour' => 4, 'monthday' => 1 }, },
        backups             => $backups, 
    }

The "backups" variable in Hiera would be in the same format as above, 
for example

    rsnapshot::backups:
        - '/etc/': 'backup.domain.com/'
        - '/var/backups/local/': 'backup.domain.com/'
        - 'root@server.domain.com:/etc/': 'server.domain.com/'

Note that the titles of the rsnapshot::cron resources need to match those given 
for retains in the main class - here "daily", "weekly" and "monthly". Also note 
that the "retain" parameters _need_ to be determined in the correct order, or 
rsnapshot will start "eating" its own backups; the more frequent backups (e.g. 
"daily") should be defined earlier than and also run before the less frequent 
ones (e.g. "monthly). Aping the above configuration is probably the safest bet.

Use the _rsnapshot::allow_ class to allow connections to hosts to be backed up:

    classes:
        - rsnapshot::allow
    
    rsnapshot::allow::host: '10.122.49.4'
    rsnapshot::allow::key: '<rsnapshot's public key as a string>'

The IP address is added to SSH authorized_keys options, so that the given key is 
only valid if the connection comes from the given host.

Finally run "rsnapshot daily" or such manually, and accept the SSH keys as 
needed. Later this manual procedure should be replaced with exported SSH host 
keys (sshkey type) that are collected on the rsnapshot host.

# Monitoring backups

This module contains a class *rsnapshot::marker* that can be used to add
"backup marker files". The idea is that cron updates the timestamp of the
marker file, by default on a daily basis, and that marker file gets backed up.

On the rsnapshot server side the timestamps of the marker files allow gathering
metrics about backup age, e.g. with Prometheus Node Exporter's Textfile
Collector. If marker files are too old, the most likely cause is that backups
are failing and an alert should be sent.

# Reference

For more details on module usage refer to these source files:

* [Class: rsnapshot](manifests/init.pp)
* [Class: rsnapshot::allow](manifests/allow.pp)
* [Class: rsnapshot::marker](manifests/marker.pp)
* [Define: rsnapshot::cron](manifests/cron.pp)
