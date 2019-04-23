#!/bin/bash
EXTRA_VARS="aip_node_count=${aip_node_count:-2}" ./aws_aip.sh -i expand.ini -i inventory.aws_ec2.yml --limit localhost "$@"
./aws_inventory.sh --graph
