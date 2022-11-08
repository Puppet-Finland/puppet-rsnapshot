#!/bin/sh
#
# https://github.com/Puppet-Finland/prometheus-rsnapshot-metrics
#
# Produce Prometheus backup metrics from rsnapshot data
#
usage() {
  echo "Usage: create-rsnapshot-prometheus-metrics.sh [-b backup directory] [-m marker file name] [-a maximum marker file age] [-d maximum search depth]"
}

### Set the defaults
#
# The base directory from where to look for marker files.
LATEST_BACKUP_DIRECTORY="/var/backups/rsnapshot/daily.0"

# Name of the marker file to look for.
MARKER_NAME=".rsnapshot-marker"

# Maximum allowable backup age in days. If older, the backup will added to the
# rsnapshot_targets_outdated metric.
MAX_BACKUP_AGE_DAYS=2

# Descent to one directory down from "/". For example /etc/.rsnapshot-marker
# will be found at this depth.
MAX_DEPTH=3

### Process commmand-line options which may or may not override the defaults
while getopts "b:m:a:d:" opt; do
    case $opt in
        b) LATEST_BACKUP_DIRECTORY=$OPTARG ;;
	m) MARKER_NAME=$OPTARG ;;
	a) MAX_BACKUP_AGE_DAYS=$OPTARG ;;
	d) MAX_DEPTH=$OPTARG ;;
    esac
done

### Validate parameters

FAIL=0

if ! [ -d "${LATEST_BACKUP_DIRECTORY}" ]; then
    echo "ERROR: parameter -b must point to a directory!"
    FAIL=1
fi

echo "${MAX_BACKUP_AGE_DAYS}"|grep -E '^[0-9]+$' > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR: parameter -a must be an integer!"
    FAIL=1
fi

echo "${MAX_DEPTH}"|grep -E '^[0-9]+$' > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR: parameter -d must be an integer!"
    FAIL=1
fi

if [ $FAIL -eq 1 ]; then
    echo
    usage
    exit 1
fi

### Generate metrics

RSNAPSHOT_TARGETS_TOTAL=$(find "${LATEST_BACKUP_DIRECTORY}" -mindepth 1 -maxdepth 1 -type d|wc --lines)
RSNAPSHOT_MARKERS_TOTAL=$(find "${LATEST_BACKUP_DIRECTORY}" -maxdepth $MAX_DEPTH -name "${MARKER_NAME}"|wc --lines)
RSNAPSHOT_TARGETS_OUTDATED=$(find "${LATEST_BACKUP_DIRECTORY}" -maxdepth $MAX_DEPTH -name "${MARKER_NAME}" -mtime +$MAX_BACKUP_AGE_DAYS|wc --lines)

echo "# HELP rsnapshot_targets_total Number of rsnapshot backup targets"
echo "# TYPE rsnapshot_targets_total gauge"
echo "rsnapshot_targets_total ${RSNAPSHOT_TARGETS_TOTAL}"

echo "# HELP rsnapshot_markers_total Number of rsnapshot backup markers"
echo "# TYPE rsnapshot_markers_total gauge"
echo "rsnapshot_markers_total ${RSNAPSHOT_MARKERS_TOTAL}"

echo "# HELP rsnapshot_targets_outdated Number of rsnapshot backup targets that have not been backed up recently"
echo "# TYPE rsnapshot_targets_outdated gauge"
echo "rsnapshot_targets_outdated ${RSNAPSHOT_TARGETS_OUTDATED}"
