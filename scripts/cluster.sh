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
source $scriptpath/scripts/common.sh
source $scriptpath/scripts/start_component.sh

control_data_port=$start_control_data_port
monitoring_data_port=$start_monitoring_data_port
hypervisor_port=$start_hypervisor_port
leader_election_data_port=$start_leader_election_data_port
group_manager_heartbeat_mcast_port=$start_group_manager_heartbeat_mcast_port

# Start the cluster
start_cluster () {
    echo "$log_tag Starting the cluster!"
    
    update_configuration_file
    start_zookeeper
    configure_and_start_bootstrap_nodes
    configure_and_start_group_managers
    configure_and_start_local_controllers
}

# Starts zookeeper
start_zookeeper () {
    echo "$log_tag Starting ZooKeeper"
    $zookeeper_init_file start
}

# Stops zookeeper
stop_zookeeper () {
    echo "$log_tag Stopping ZooKeeper"
    $zookeeper_init_file stop
}

# Update the configutation file
update_configuration_file () {
    cp $node_config_file "./configs/snooze_node.cfg" 2> /dev/null
    if [ $? -ne 0 ]
    then
        echo "$log_tag Unable to update configuation file! Falling back to original!"
    fi
    
    cp $node_log_file "./configs/log4j.xml" 2> /dev/null
    if [ $? -ne 0 ]
    then
        echo "$log_tag Unable to update logger configuration file! Falling back to original!"
    fi
}

# Stop the cluster
stop_cluster () {
    echo "$log_tag Stoping the cluster!"
    clean_tmp_files
    kill -9 `ps ax | grep $node_jar_file | grep -v grep | awk '{print $1}'` > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
        echo "$log_tag Unable to kill the Snooze processes!"
        return
    fi
    
    stop_zookeeper
}

# Generates the bootstap configs and start the nodes
configure_and_start_bootstrap_nodes () {
    echo "$log_tag Generating bootstrap files!"
    for (( I=0; $I < $number_of_bootstrap_nodes; I++ ))
    do
        echo "$log_tag Bootstrap node: $I, control data port: $control_data_port"
        
        # configs
        generate_bootstrap_config $I $control_data_port
           
        # start
        start_snooze_node "./tmp/snooze_node_bs_$I.cfg" "./tmp/log4j_bs_$I.xml"
        
        control_data_port=$(($control_data_port+1))
    done  
}

# Generate the group manager configs
configure_and_start_group_managers () {
    echo "$log_tag Generating group manager files!"
    for (( I=0; $I < $number_of_group_managers; I++ ))
    do
        echo "$log_tag Group manager: $I, control data port: $control_data_port, monitoring data port: 
              $monitoring_data_port, leader election data port: $leader_election_data_port,
              group manager multicast port: $group_manager_heartbeat_mcast_port"
        
        # configs
        generate_group_manager_config $I $control_data_port $monitoring_data_port $group_manager_heartbeat_mcast_port
        
        # start
        start_snooze_node "./tmp/snooze_node_gm_$I.cfg" "./tmp/log4j_gm_$I.xml"
                
        control_data_port=$(($control_data_port+1))
        monitoring_data_port=$(($monitoring_data_port+1))
        group_manager_heartbeat_mcast_port=$(($group_manager_heartbeat_mcast_port+1))
    done  
}

# Generate the local controller configs
configure_and_start_local_controllers () {
    echo "$log_tag Generating local controller files!"
    for (( I=0; $I < $number_of_local_controllers; I++ ))
    do
        echo "$log_tag Local controller: $I, control data port: $control_data_port,
              hypervisor port: $hypervisor_port"
        
        generate_local_controller_config $I $control_data_port $hypervisor_port
        start_snooze_node "./tmp/snooze_node_lc_$I.cfg" "./tmp/log4j_lc_$I.xml"
        
        control_data_port=$(($control_data_port+1))
        hypervisor_port=$(($hypervisor_port+1))
    done  
}
