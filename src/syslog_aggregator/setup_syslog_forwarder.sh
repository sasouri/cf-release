#!/usr/bin/env sh

if [ $# -ne 1 ]
then
    echo "Usage: setup_syslog_forwarder.sh [Config dir]"
    exit 1
fi

CONFIG_DIR=$1

# Place to spool logs if the upstream server is down
mkdir -p /var/vcap/sys/rsyslog/buffered
chown -R syslog:adm /var/vcap/sys/rsyslog/buffered

cp $CONFIG_DIR/syslog_forwarder.conf /etc/rsyslog.d/00-syslog_forwarder.conf

if [ "`pgrep wsh`" = '1' ]; then
    # we are in a warden contrainer. Upstart commands are not working.
    killall rsyslogd || true
    /usr/sbin/rsyslogd
else
    /usr/sbin/service rsyslog restart
fi
