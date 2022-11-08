#
# @summary
#   Update a marker file daily. The timestamp can be used on the rsnapshot
#   server side by, say, Prometheus Node Exporter Textfile Collector script to
#   generate metrics. The metrics will tell if (some) backups are failing.
#
# @param path
#   The path to the marker file
# @param hour
#   The hour when the marker file is updated with cron
# @param minute
#   The minute when the marker file is updated with cron
# @param weekday
#   The weekday when the market file is updated with cron
#
class rsnapshot::marker (
  Stdlib::Absolutepath                                                $path,
  Variant[Array[String], Array[Integer[0-23]], String, Integer[0-23]] $hour,
  Variant[Array[String], Array[Integer[0-59]], String, Integer[0-59]] $minute,
  Variant[Array[String], Array[Integer[0-7]],  String, Integer[0-7]]  $weekday,
) {
  cron { 'update rsnapshot-marker file':
    user        => 'root',
    command     => "touch ${path}",
    hour        => $hour,
    minute      => $minute,
    weekday     => $weekday,
    environment => ['PATH=/bin:/sbin:/usr/bin:/usr/sbin'],
  }
}
