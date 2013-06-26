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

# Generates the bootstrap config
generate_bootstrap_config () {
    # config
    cp ./configs/snooze_node.cfg ./tmp/snooze_node_bs_$1.cfg
    perl -pi -e "s/^network.listen.controlDataPort.*/network.listen.controlDataPort = $2/" "./tmp/snooze_node_bs_$1.cfg"

    # log4j
    sed 's/snooze_node.log/snooze_node_bs_'$1'.log/g' "./configs/log4j.xml" > "./tmp/log4j_bs_$1.xml" 
}

# Generates the group manager config
generate_group_manager_config () {
    # General settings
    cp ./configs/snooze_node.cfg ./tmp/snooze_node_gm_$1.cfg
    perl -pi -e "s/^node.role.*/node.role = groupmanager/" "./tmp/snooze_node_gm_$1.cfg"
        
    # Networking settings
    perl -pi -e "s/^network.listen.controlDataPort.*/network.listen.controlDataPort = $2/" "./tmp/snooze_node_gm_$1.cfg"
    perl -pi -e "s/^network.listen.monitoringDataPort.*/network.listen.monitoringDataPort = $3/" "./tmp/snooze_node_gm_$1.cfg"
    perl -pi -e "s/^network.multicast.groupManagerHeartbeatPort.*/network.multicast.groupManagerHeartbeatPort = $4/" "./tmp/snooze_node_gm_$1.cfg"
    
    # Logger settings
    sed 's/snooze_node.log/snooze_node_gm_'$1'.log/g' "./configs/log4j.xml" > "./tmp/log4j_gm_$1.xml"
}

# Generates the local controller config
generate_local_controller_config () {
    # General settings
    sed 's/^network.listen.controlDataPort.*/network.listen.controlDataPort = '$2'/g' "./configs/snooze_node.cfg" > "./tmp/snooze_node_lc_$1.cfg" 
    perl -pi -e "s/^node.role.*/node.role = localcontroller/" "./tmp/snooze_node_lc_$1.cfg"
    perl -pi -e "s/^hypervisor.port.*/hypervisor.port = $3/" "./tmp/snooze_node_lc_$1.cfg"
    
    # Logger settings
    sed 's/snooze_node.log/snooze_node_lc_'$1'.log/g' "./configs/log4j.xml" > "./tmp/log4j_lc_$1.xml"
}

# Generates a libvirt config
generate_libvirt_config ()
{
    sed 's/^tcp_port.*/tcp_port = \"'$2'\"/g' "./configs/distributions/$DISTRIBUTION/libvirtd.conf" > "./tmp/snooze_libvirtd_$1.conf"
}
