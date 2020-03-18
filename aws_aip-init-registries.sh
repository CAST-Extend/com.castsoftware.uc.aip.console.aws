#!/bin/bash
# clean cache for previous started nodes
rm -fr provision/aip-nodes
# The command bellow applys to hosts in expand stage only.

# While in Dev activities:
#
# Run a group of tasks with the same tag on already inited nodes:
# ./aws_aip-node.sh -t tags --limit "aip_node_hosts:&init"

[[ -f $HOME/.aip-aws ]] && source "$HOME/.aip-aws"
WIN_ADMIN_PASSWORD=${WIN_ADMIN_PASSWORD:?"Missing Windows Administrator password"}
EXTRA_VARS="win_admin_password=$WIN_ADMIN_PASSWORD"
[[ -n "$s3_BUCKET" ]] && EXTRA_VARS="$EXTRA_VARS cast_aip_s3_bucket=$s3_BUCKET"
# In case a flat is used, the cast_aip_install_dir is changed accordingly
[[ -n "$CAST_FLAT_AIP_ZIP" ]] && EXTRA_VARS="$EXTRA_VARS cast_flat_aip_zip=$CAST_FLAT_AIP_ZIP cast_aip_install_dir=C:/${CAST_FLAT_AIP_ZIP%%.zip}"

#EXTRA_VARS="$EXTRA_VARS" \
#    ./aws_aip.sh -i inventory.aws_ec2.yml --limit "aip_*_registry:&expand" "$@"
EXTRA_VARS="$EXTRA_VARS" \
    ./aws_aip.sh -i inventory.aws_ec2.yml  "$@"
