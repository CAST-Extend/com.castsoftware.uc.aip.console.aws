#!/bin/bash

EXTRA_VARS="stack_name=${NAME:?"Give stack a name"} aip_console_port=${PORT:?"Give stack a port"} aip_node_count=${AIP_NODE_COUNT:-1}"

EXTRA_VARS="$EXTRA_VARS" \
PLAYBOOK="provision/deploy_stack.yml" \
    ./aws_aip.sh -i inventory.aws_ec2.yml  "$@"
