#
# == Define: rsnapshot::interval
#
# Configure rsnapshot's schedules and retaining periods
#
# == Parameters
#
# [*title*]
#   Although not strictly a parameter, the resource title is used as an 
#   identifier for both rsnapshot and puppet. Typically it would be 'hourly', 
#   'daily', 'weekly' or 'monthly', with the appropriate schedule.
# [*retain*]
#   How many backups of this type (e.g. daily) to keep
# [*minute*]
#   Minute(s) when this rsnapshot job gets run. No default value.
# [*hour*]
#   Hour(s) when this rsnapshot job gets run. Defaults to '*' (all hours)
# [*weekday*]
#   Weekday(s) when this rsnapshot job gets run. Defaults to '*' (all weekdays).
# [*monthday*]
#   Day(s) of the month when this rsnapshot job gets run. Defaults to '*' (all
#   days of the month).
# [*email*]
#   Email address where notifications are sent. Defaults to top-scope variable
#   $::servermonitor.
#
# == Examples
#
# A typical setup might look like this:
#
# rsnapshot::interval { 'hourly':
#   retain => 24,
#   minute => 40,
# }
#
# rsnapshot::interval { 'daily':
#   retain => 7,
#   minute => 40,
#   hour => 4,
# }
#
# rsnapshot::interval { 'weekly':
#   retain => 4,
#   minute => 20,
#   hour => 5,
#   weekday => 6,
# }
#
# rsnapshot::interval { 'monthly':
#   retain => 6,
#   minute => 0,
#   hour => 6,
#   monthday => 1,
# }
#
define rsnapshot::interval
(
    $retain,
    $minute,
    $hour='*',
    $weekday='*',
    $monthday='*',
    $email=$::servermonitor
)
{
    # Setup a cronjob
	cron { "rsnapshot-${title}":
		ensure => present,
		command => "rsnapshot ${title}",
		user => root,
		hour => $hour,
		minute => $minute,
        weekday => $weekday,
        monthday => $monthday,
        environment => [ 'PATH=/bin:/usr/bin:/usr/sbin', "MAILTO=${email}" ],
	}

    # Add a "retain" line to rsnapshot.conf
    Rsnapshot::Config::File <| title == 'default-rsnapshot.conf' |> {
        retains +> "${title}	${retain}",
    }
}
