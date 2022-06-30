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
# See README.md in the module root directory.
#
define rsnapshot::cron (
  Variant[String,Integer] $minute,
  Variant[String,Integer] $hour='*',
  Variant[String,Integer] $weekday='*',
  Variant[String,Integer] $monthday='*',
  Optional[String]        $email = $rsnapshot::email,

) {
  include rsnapshot::params

  # Set email for the cronjob if it is present
  if $email {
    $cron_environment = ['PATH=/bin:/usr/bin:/usr/sbin', "MAILTO=${email}"]
  } else {
    $cron_environment = ['PATH=/bin:/usr/bin:/usr/sbin']
  }

  # Setup a cronjob
  cron { "rsnapshot-${title}":
    ensure      => present,
    command     => "rsnapshot ${title}",
    user        => 'root',
    hour        => $hour,
    minute      => $minute,
    weekday     => $weekday,
    monthday    => $monthday,
    environment => $cron_environment,
  }
}
