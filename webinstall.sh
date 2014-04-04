#!/usr/bin/env bash

# track the current directory
TOP_DIR=$(cd $(dirname "$0") && pwd)
SCRIPT_DIR="$TOP_DIR/snooze-deploy-localcluster"
REPO="https://github.com/snoozesoftware/snooze-deploy-localcluster"

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

http_proxy=$http_proxy\
https_proxy=$https_proxy\
git clone $REPO

# launch the automatic installer
$SCRIPT_DIR/install.sh 




