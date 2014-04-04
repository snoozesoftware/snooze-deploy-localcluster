#!/usr/bin/env bash

# Base directory
TOP_DIR=$(cd $(dirname "$0") && pwd)

# Import common functions
source $TOP_DIR/lib/functions-common
source $TOP_DIR/lib/functions-extra
source $TOP_DIR/lib/settings

SNOOZENODE_FILES_DESTINATION=$TOP_DIR/files/snoozenode
SNOOZEIMAGES_FILES_DESTINATION=$TOP_DIR/files/snoozeimages
SNOOZEEC2_FILES_DESTINATION=$TOP_DIR/files/snoozeec2

# Determine what system we are running on.  This provides ``os_VENDOR``,
# ``os_RELEASE``, ``os_UPDATE``, ``os_PACKAGE``, ``os_CODENAME``
# and ``DISTRO``
GetDistro
echo "You are running "
echo $os_RELEASE / $os_PACKAGE / $os_CODENAME


if [[ $EUID -eq 0 ]]; then
    echo "You are running this script as root."
fi

is_package_installed sudo || install_package sudo

[[ -z "$PACKAGES" ]] && die "PACKAGES list is not set. Exiting."

echo "Installing required packages"
for i in $PACKAGES; 
do
  echo "Installing $i"
  is_package_installed $i || install_package $i 
  echo "$i installed"
done


## Create the user SNOOZEADMIN / SNOOZE 
if ! getent group $SNOOZEGROUP > /dev/null; then
  echo "Creating the group $SNOOZEGROUP"
  sudo groupadd $SNOOZEGROUP
fi

if ! getent passwd $SNOOZEADMIN > /dev/null; then
  echo "Creating the user $SNOOZEADMIN"
  sudo useradd -s /bin/false $SNOOZEADMIN -g $SNOOZEGROUP
fi

## Add user to the libvirt group
if [[ $os_VENDOR == "Ubuntu" ]]; then
  sudo adduser snoozeadmin libvirtd
elif [[ $os_VENDOR == "Debian" ]]; then
  sudo adduser snoozeadmin libvirtd
else
  exit_distro_not_supported "Add user"
fi

echo "Downloading snoozenode files"
mkdir -p $SNOOZENODE_FILES_DESTINATION

for i in $SNOOZENODE_FILES;
do
  echo "Installing $i"
  w_get "$SNOOZENODE_FILES_LOCATION/$i" "$SNOOZENODE_FILES_DESTINATION/$i"
done

echo "Downloading snoozenode files"
mkdir -p $SNOOZEEC2_FILES_DESTINATION

for i in $SNOOZEEC2_FILES;
do
  echo "Installing $i"
  w_get "$SNOOZEEC2_FILES_LOCATION/$i" "$SNOOZEEC2_FILES_DESTINATION/$i"
done

echo "Downloading snoozenode files"
mkdir -p $SNOOZEIMAGES_FILES_DESTINATION

for i in $SNOOZEIMAGES_FILES;
do
  echo "Installing $i"
  w_get "$SNOOZEIMAGES_FILES_LOCATION/$i" "$SNOOZEIMAGES_FILES_DESTINATION/$i"
done


## change jars/configs location in scripts/settings.sh 
perl -pi -e "s,^install_directory.*,install_directory=\"$SNOOZENODE_FILES_DESTINATION\"," "$TOP_DIR/scripts/settings.sh"
perl -pi -e "s,^node_jar_file.*,node_jar_file=\"\\\$install_directory/snoozenode.jar\"," "$TOP_DIR/scripts/settings.sh"
perl -pi -e "s,^node_config_file.*,node_config_file=\"\\\$install_directory/snooze_node.cfg\"," "$TOP_DIR/scripts/settings.sh"
perl -pi -e "s,^node_log_file.*,node_log_file=\"\\\$install_directory/log4j.xml\"," "$TOP_DIR/scripts/settings.sh"


perl -pi -e "s,^snoozeimages_install_directory.*,snoozeimages_install_directory=\"$SNOOZEIMAGES_FILES_DESTINATION\"," "$TOP_DIR/scripts/settings.sh"
perl -pi -e "s,^snoozeimages_node_jar_file.*,snoozeimages_node_jar_file=\\\$snoozeimages_install_directory/snoozeimages.jar," "$TOP_DIR/scripts/settings.sh"
perl -pi -e "s,^snoozeimages_config_file.*,snoozeimages_config_file=\"\\\$snoozeimages_install_directory/snooze_images.cfg\"," "$TOP_DIR/scripts/settings.sh"
perl -pi -e "s,^snoozeimages_log_file.*,snoozeimages_log_file=\"\\\$snoozeimages_install_directory/log4j.xml\"," "$TOP_DIR/scripts/settings.sh"

perl -pi -e "s,^snoozeec2_install_directory.*,snoozeec2_install_directory=\"$SNOOZEEC2_FILES_DESTINATION\"," "$TOP_DIR/scripts/settings.sh"
perl -pi -e "s,^snoozeec2_node_jar_file.*,snoozeec2_node_jar_file=\\\$snoozeec2_install_directory/snoozeec2.jar," "$TOP_DIR/scripts/settings.sh"
perl -pi -e "s,^snoozeec2_config_file.*,snoozeec2_config_file=\"\\\$snoozeec2_install_directory/snooze_ec2.cfg\"," "$TOP_DIR/scripts/settings.sh"
perl -pi -e "s,^snoozeec2_log_file.*,snoozeec2_log_file=\"\\\$snoozeec2_install_directory/log4j.xml\"," "$TOP_DIR/scripts/settings.sh"
perl -pi -e "s,^snoozeec2_instances_file.*,snoozeec2_instances_file=\"\\\$snoozeec2_install_directory/instances\"," "$TOP_DIR/scripts/settings.sh"

## Installation of snoozeimages
pool=$(virsh -q pool-list --all)
if [[ -z $pool ]] 
then
  echo "Defining a new default pool"
  sudo virsh pool-define-as --name default --target /var/lib/libvirt/images --type dir
  sudo virsh pool-build default
  sudo virsh pool-start default
fi

