#!/bin/bash
EXTRA_VARS="aip_node_count=${aip_node_count:-1}" ./aws_aip.sh -i expand.ini "$@"
./aws_inventory.sh --graph
