#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Please specify cluster name!" && exit 1
fi

PEG_ROOT=$(dirname ${BASH_SOURCE})/../..
source ${PEG_ROOT}/util.sh

CLUSTER_NAME=$1
WORKERS_PER_NODE=4

PUBLIC_DNS=$(fetch_cluster_public_dns ${CLUSTER_NAME})

MASTER_DNS=$(fetch_cluster_master_public_dns ${CLUSTER_NAME})
WORKER_DNS=$(fetch_cluster_worker_public_dns ${CLUSTER_NAME})

# Configure base Storm nimbus and supervisors
single_script="${PEG_ROOT}/config/storm/setup_single.sh"
args="${WORKERS_PER_NODE} ${MASTER_DNS} ${WORKER_DNS}"
for dns in ${PUBLIC_DNS}; do
  run_script_on_node ${dns} ${single_script} ${args} &
done

wait

echo "Storm configuration complete!"

