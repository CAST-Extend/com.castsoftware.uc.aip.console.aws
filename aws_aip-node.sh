#!/bin/bash
# clean cache for previous started nodes
rm -fr provision/aip-nodes
# The command bellow applys to hosts in expand stage only.

# While in Dev activities:
#
# Run a group of tasks with the same tag on already inited nodes:
# ./aws_aip-node.sh -t tags --limit "aip_node_hosts:&init"

# In case a flat is used, change the cast_aip_install_dir
source ~/.aip-aws
[[ -n "$CAST_FLAT_AIP_ZIP" ]] && export EXTRA_VARS="$EXTRA_VARS cast_flat_aip_zip=$CAST_FLAT_AIP_ZIP cast_aip_install_dir=C:/${CAST_FLAT_AIP_ZIP%%.zip}"
./aws_aip.sh -i inventory.aws_ec2.yml --limit "aip_node_hosts:&expand" "$@"
