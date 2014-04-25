#!/usr/bin/env bash


client="files/snoozeclient/snoozeclient.jar"

cfg_file="files/snoozeclient/snooze_client.cfg"
log_file="files/snoozeclient/log4j.xml"

java -jar $client $cfg_file $log_file "$@"
