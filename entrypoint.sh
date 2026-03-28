#!/bin/bash
set -e

# rsyslogを起動してPapertrailにログを転送する
# PAPERTRAIL_TOKENはHeroku Config Varsで設定すること
: "${PAPERTRAIL_TOKEN:?PAPERTRAIL_TOKEN is not set}"
envsubst '${PAPERTRAIL_TOKEN}' < /etc/rsyslog.d/99-solarwinds.conf.tmpl > /etc/rsyslog.d/99-solarwinds.conf
rsyslogd

# pumaを起動
exec bundle exec puma -C config/puma.rb
