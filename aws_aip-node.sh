#!/bin/bash
# Apply playbook on default stage=expand (newly created machines)
# Use stage=init to apply playbook again on initialized node
rm -fr provision/aip-nodes
# limit play to hosts in expand stage
# to run a group of tasks with the same tag:
# -t tags --limit "aip_node_hosts:&init"
./aws_aip.sh -i inventory.aws_ec2.yml --limit "aip_node_hosts:&expand" "$@"
