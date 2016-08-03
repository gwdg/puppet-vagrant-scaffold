#!/bin/bash
# Copyright 2016 GWDG
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

BASE_PATH=`puppet config print confdir`
MODULE_PATH=`puppet config print modulepath | cut -d ':' -f 1`
PUPPET_ENVIRONMENT="$BASE_PATH/environments/"
PUPPET_MANIFEST_PATH=`puppet config print manifestdir`

SCRIPT_NAME=$(basename $0)
SCRIPT_DIR=$(readlink -f "$(dirname $0)")

MODULE_SOURCE_BASE=${MODULE_SOURCE_BASE:-$SCRIPT_DIR/../..}

echo "127.0.1.1 gerrit" >> /etc/hosts

# Module
ln -s $MODULE_SOURCE_BASE $MODULE_PATH/ci-infra

# Hiera 
ln -s $MODULE_PATH/ci-infra/puppet/hiera.yaml $BASE_PATH/hiera.yaml
ln -s $MODULE_PATH/ci-infra/puppet/hiera/common.yaml $PUPPET_ENVIRONMENT/common.yaml

# Site.pp
ln -s $MODULE_PATH/ci-infra/assets/puppet/site-review.pp $PUPPET_MANIFEST_PATH/site-review.pp
ln -s $MODULE_PATH/ci-infra/assets/puppet/site-ci.pp $PUPPET_MANIFEST_PATH/site-ci.pp
ln -s $MODULE_PATH/ci-infra/assets/puppet/site-both.pp $PUPPET_MANIFEST_PATH/site-both.pp
