#!/bin/bash
#
# Copyright (C) 2010-2012 Eugen Feller, INRIA <eugen.feller@inria.fr>
#
# This file is part of Snooze, a scalable, autonomic, and
# energy-aware virtual machine (VM) management framework.
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses>.
#

libvirt_command="/usr/sbin/libvirtd -d -l"

# Starts a single snooze node
start_snooze_node () {
    echo "$log_tag Starting cluster component with parameters: $@"
    cfg_file=$1
    shift
    log_file=$1
    shift
    JVM_OPTS=""
    while(($#)); do
        JVM_OPTS="$JVM_OPTS $1"
        shift
    done
    command="java $JVM_OPTS -jar $node_jar_file $cfg_file $log_file &"
    echo $command
    su -s /bin/bash $username -c "$command"
    sleep $sleep_time
}

# Starts the libvirt
start_libvirt_node () {
    echo "$log_tag Starting libvirt with parameters: $@"
    echo "$libvirt_command -p /tmp/snooze_libvirtd_$1.pid -f $2"
    $libvirt_command -p /tmp/snooze_libvirtd_$1.pid -f "$2"
}

# start the snoozeimages service 
start_snoozeimages () {
  cfg_file=$1
  log_file=$2
  command="java -jar $snoozeimages_jar_file $cfg_file $log_file &"
  echo $command
  su -s /bin/bash $username -c "$command"
}

# start the snoozeec2 service 
start_snoozeec2 () {
  cfg_file=$1
  instance_file=$2
  log_file=$3
  command="java -jar $snoozeec2_jar_file $cfg_file $instance_file $log_file &"
  echo $command
  su -s /bin/bash $username -c "$command"
}
