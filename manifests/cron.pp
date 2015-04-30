#
# == Define: rsnapshot::cron
#
# Configure rsnapshot's schedules.
#
# Retain period unfortunately have to be configured in the main rsnapshot class 
# due to Puppet's unordered execution model coupled with rsnapshot's dependence 
# on correct ordering for the retain lines.
#
# == Parameters
#
# [*title*]
#   Although not strictly a parameter, the resource title is used as an 
#   identifier for both rsnapshot and puppet. Typically it would be 'hourly', 
#   'daily', 'weekly' or 'monthly', with the appropriate schedule.
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
#   rsnapshot::cron { 'hourly':
#       minute => 40,
#   }
#   
#   rsnapshot::cron { 'daily':
#       minute => 40,
#       hour => 4,
#   }
#   
#   rsnapshot::cron { 'weekly':
#       minute => 20,
#       hour => 5,
#       weekday => 6,
#   }
#   
#   rsnapshot::cron { 'monthly':
#       minute => 0,
#       hour => 6,
#       monthday => 1,
#   }
#
define rsnapshot::cron
(
    $minute,
    $hour='*',
    $weekday='*',
    $monthday='*',
    $email=$::servermonitor
)
{

    include ::rsnapshot::params

    # Setup a cronjob
    cron { "rsnapshot-${title}":
        ensure      => present,
        command     => "rsnapshot ${title}",
        user        => $::os::params::adminuser,
        hour        => $hour,
        minute      => $minute,
        weekday     => $weekday,
        monthday    => $monthday,
        environment => [ 'PATH=/bin:/usr/bin:/usr/sbin', "MAILTO=${email}" ],
    }
}
