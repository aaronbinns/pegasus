#!/bin/bash

# check input arguments
if [ "$#" -ne 1 ]; then
    echo "Please specify cluster name!" && exit 1
fi

PEG_ROOT=$(dirname ${BASH_SOURCE})/../..
source ${PEG_ROOT}/util.sh

CLUSTER_NAME=$1

PUBLIC_DNS=($(fetch_cluster_public_dns ${CLUSTER_NAME}))

script=${PEG_ROOT}/install/environment/install_env.sh

# Install environment packages to master and slaves
for dns in "${PUBLIC_DNS[@]}"; do
  run_script_on_node ${dns} ${script} &
done

wait

echo "Environment installed!"
