#!/usr/bin/env bash

# track the current directory
TOP_DIR=$(cd $(dirname "$0") && pwd)
SCRIPT_DIR="$TOP_DIR/snooze-deploy-localcluster"

if [ -z $(which git) ]
then
  echo "git is required"
  echo "please install git"
  exit 1
fi

if [ -d "./snooze-deploy-localcluster" ]
then
  echo "Your local directory already contains snooze-deploy-localcluster"
  echo "Please save/remove it or cd to another directory"
  exit 1
fi

git clone https://github.com/msimonin/snooze-deploy-localcluster
cd $SCRIPT_DIR && git checkout develop

# launch the automatic installer
$SCRIPT_DIR/install.sh 




