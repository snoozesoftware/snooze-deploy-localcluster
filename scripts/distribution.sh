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

function set_distribution {
# Check the distribution
    DISTRIBUTION=

    if [ -x /usr/bin/lsb_release ];then
        dist=$(/usr/bin/lsb_release -i|cut -f 2)
        case $dist in
            Debian )
                DISTRIBUTION="debian"
            ;;
            Ubuntu )
                DISTRIBUTION="ubuntu"
            ;;
            CentOS )
                DISTRIBUTION="centos"
            ;;
        esac
    fi

#no lsb_release, try detection of distribution-specific files
    if [ ! $DISTRIBUTION ];then
        if [ -d "/etc/sysconfig" ];then
            DISTRIBUTION="centos"
        elif [ -f "/etc/network/interfaces" ];then
            DISTRIBUTION="debian"
        fi
    fi

}

