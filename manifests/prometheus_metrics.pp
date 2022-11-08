#
# @summary
#   Generate Prometheus Textfile Collector metrics from rsnapshot backups
#
# @param metrics_file
#   File to save metrics to. Must be in the Textfile Collector metrics directory.
# @param latest_backup_directory
#   Directory with the latest rsnapshot backups (typically called "daily.0")
# @param marker_name
#   Name of the marker file (not full path)
# @param max_backup_age_days
#   Maximum marker file modification time in days - if older, backup is marked
#   as outdated
# @param max_depth
#   Maximum search depth. The default value (3) will find marker files from one level down
#   from root (e.g. /etc/.rsnapshot-marker)
# @param hour
#   Hour of day when to generate metrics. Should happen soon after a daily backup run.
# @param minute
#   Minute when to generate metrics.
# @param weekday
#   Weekday when to generate metrics.
#
class rsnapshot::prometheus_metrics (
  Stdlib::AbsolutePath                                                $metrics_file,
  Stdlib::AbsolutePath                                                $latest_backup_directory,
  String                                                              $marker_name,
  Integer                                                             $max_backup_age_days,
  Integer                                                             $max_depth,
  Variant[Array[String], Array[Integer[0-23]], String, Integer[0-23]] $hour,
  Variant[Array[String], Array[Integer[0-59]], String, Integer[0-59]] $minute,
  Variant[Array[String], Array[Integer[0-7]],  String, Integer[0-7]]  $weekday,
) {
  $script = '/usr/local/bin/create-rsnapshot-prometheus-metrics.sh'

  file { $script:
    ensure  => file,
    content => epp('rsnapshot/create-rsnapshot-prometheus-metrics.sh'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  cron { 'update rsnapshot prometheus metrics':
    ensure  => present,
    command => "${script} -b ${latest_backup_directory} -m ${marker_name} -a ${max_backup_age_days} -d ${max_depth} > ${metrics_file}",
    user    => 'root',
    hour    => $hour,
    minute  => $minute,
    weekday => $weekday,
    require => File[$script],
  }
}
