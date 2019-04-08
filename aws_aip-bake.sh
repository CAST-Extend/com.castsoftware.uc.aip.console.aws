#!/bin/bash
set -x
PLAYBOOK="provision/aws_aip_node_bake.yml" \
    ./aws_aip.sh
