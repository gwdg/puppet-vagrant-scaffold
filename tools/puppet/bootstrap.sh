#!/bin/bash

apt-get update
apt-get -y upgrade 

SCRIPT_DIR=$(readlink -f "$(dirname $0)")

$SCRIPT_DIR/install.sh
$SCRIPT_DIR/modules.sh
$SCRIPT_DIR/setup.sh

echo "Do not forget do set hostname and /etc/hosts"
echo "Puppet Environment is ready you can run 'sudo puppet apply --debug --verbose /etc/puppet/manifests/site-<role>.pp' now"
