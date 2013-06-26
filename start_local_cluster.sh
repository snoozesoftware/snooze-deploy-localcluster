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

scriptpath=$(dirname $0)
source $scriptpath/scripts/cluster.sh
source $scriptpath/scripts/libvirt.sh
source $scriptpath/scripts/distribution.sh

set_distribution

# Prints the usage information
print_usage () {
	echo "Usage: $script_name [options]"
	echo "Contact: $author"
	echo "Options:"
	echo "-l   Start libvirt"
	echo "-d   Stop libvirt"
	echo "-s   Start cluster"
	echo "-k   Kill cluster"
}

# Process the user input
option_found=0
while getopts ":ldsk" opt; do
    option_found=1
    print_settings

    case $opt in
        l)
            start_libvirt
            return_value=$?
            ;;
        d)
            stop_libvirt
            return_value=$?
            ;;
        s)
            start_cluster
            return_value=$?
            ;;
        k)
            stop_cluster
            return_value=$?
            ;;
        \?)
            echo "$log_tag Invalid option: -$OPTARG" >&2
            print_usage
            exit $error_code
            ;;
        :)
            echo "$log_tag Missing argument for option: -$OPTARG" >&2
            print_usage
            exit $error_code
            ;;
    esac
done

if ((!option_found)); then
    print_usage 
    exit $error_code
fi

if [[ $? -ne $return_value ]]
then
    echo "$log_tag Command failed!" >&2
    exit $error_code
fi

echo "$log_tag Command executed successfully!" >&2
exit $success_code
