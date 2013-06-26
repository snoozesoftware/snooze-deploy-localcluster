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

source $scriptpath/scripts/config_generator.sh
source $scriptpath/scripts/settings.sh

hypervisor_port=$start_hypervisor_port

# Starts libvirt
start_libvirt () {
    echo "$log_tag Starting the libvirt!"
    configure_and_start_libvirt
}

# Stops libvirt
stop_libvirt ()
{
    clean_tmp_files
    clean_libvirt_pids
    kill -9 `ps ax | grep "libvirtd" | grep -v grep | awk '{print $1}'`
}

# Configures and starts libvirt instances
configure_and_start_libvirt() {
    echo "$log_tag Generating libvirt files!"
    for (( I=0; $I < $number_of_local_controllers; I++ ))
    do
        echo "$log_tag Libvirt node: $I will listen on port: $hypervisor_port"
        
        generate_libvirt_config $I $hypervisor_port
        start_libvirt_node $I "./tmp/snooze_libvirtd_$I.conf"
        
        hypervisor_port=$(($hypervisor_port+1))
    done 
}
