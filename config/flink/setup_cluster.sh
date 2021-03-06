#!/bin/bash

# check input arguments
if [ "$#" -ne 1 ]; then
    echo "Please specify cluster name!" && exit 1
fi

PEG_ROOT=$(dirname ${BASH_SOURCE})/../..
source ${PEG_ROOT}/util.sh

CLUSTER_NAME=$1

PUBLIC_DNS=$(fetch_cluster_public_dns ${CLUSTER_NAME})
MASTER_DNS=$(fetch_cluster_master_public_dns ${CLUSTER_NAME})
WORKER_DNS=$(fetch_cluster_worker_public_dns ${CLUSTER_NAME})
NUM_WORKERS=$(echo ${WORKER_DNS} | wc -w)

single_script="${PEG_ROOT}/config/flink/setup_single.sh"
args="$MASTER_DNS $NUM_WORKERS"

# Install and configure Flink on all nodes
for dns in ${PUBLIC_DNS}; do
  run_script_on_node ${dns} ${single_script} ${args} &
done

wait

master_script="${PEG_ROOT}/config/flink/config_master.sh"
args="${PUBLIC_DNS}"
run_script_on_node ${MASTER_DNS} ${master_script} ${args}

