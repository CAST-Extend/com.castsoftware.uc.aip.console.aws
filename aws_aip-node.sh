#!/bin/bash
# Apply playbook on default stage=expand (newly created machines)
# Use stage=init to apply playbook again on initialized node
rm -fr provision/aip-nodes
EXTRA_VARS="stage=${stage:-expand}" \
./aws_aip.sh -i inventory.aws_ec2.yml --limit aip_node_hosts "$@"
