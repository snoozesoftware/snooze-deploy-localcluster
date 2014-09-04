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

## Internal script settings
script_name=$(basename $0 .sh)
author="Eugen Feller <eugen.feller@inria.fr> Matthieu Simonin <matthieu.simonin@inria.fr>"
log_tag="[Snooze-Dev]"

## Exit codes
error_code=1
success_code=0

# User under which the framework should be started
username="snoozeadmin"

# Node files
install_directory="/vagrant/snoozenode"
node_jar_file="$install_directory/target/uber-snoozenode-2.1.6-SNAPSHOT.jar"
node_config_file="$install_directory/configs/framework/snooze_node.cfg"
node_log_file="$install_directory/configs/framework/log4j.xml"

# Snoozeimages files
snoozeimages_enable=true
snoozeimages_install_directory="/vagrant/snoozeimages"
snoozeimages_jar_file="$snoozeimages_install_directory/target/uber-snoozeimages-2.1.6-SNAPSHOT.jar"
snoozeimages_config_file="$snoozeimages_install_directory/configs/snooze_images.cfg"
snoozeimages_log_file="$snoozeimages_install_directory/configs/log4j.xml"

# Snoozeec2 files
snoozeec2_enable=false
snoozeec2_install_directory="/vagrant/snooze-deploy-localcluster/files/snoozeec2"
snoozeec2_jar_file="$snoozeec2_install_directory/snoozeec2.jar"
snoozeec2_config_file="$snoozeec2_install_directory/snooze_ec2.cfg"
snoozeec2_instances_file="$snoozeec2_install_directory/instances"
snoozeec2_log_file="$snoozeec2_install_directory/log4j.xml"
# Start method

sleep_time=0

# ZooKeeper
zookeeper_init_file="/usr/share/zookeeper/bin/zkServer.sh"

# JMX 
jmx_enable=true
jmx_authenticate=false
jmx_ssl=false

# Start ports
start_control_data_port=5000
start_monitoring_data_port=6000
start_group_manager_heartbeat_mcast_port=10000
start_hypervisor_port=16509
snoozeimages_port=4000
snoozeec2_port=4001

## Cluster size 
number_of_bootstrap_nodes=1
number_of_group_managers=2
number_of_local_controllers=1


print_settings() 
{   
    echo "<------------------------------------------->"
    echo "$log_tag Number of bootstrap nodes: $number_of_bootstrap_nodes"
    echo "$log_tag Number of group managers: $number_of_group_managers"
    echo "$log_tag Number of local controllers: $number_of_local_controllers"
    echo "<------------------------------------------->"
}
