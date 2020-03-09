#!/bin/bash
[[ -f $HOME/.aip-aws ]] && source "$HOME/.aip-aws"

# Win administrator password
[[ -n "$WIN_ADMIN_PASSWORD" ]] && EXTRA_VARS="${EXTRA_VARS} win_admin_password=$WIN_ADMIN_PASSWORD"

# CAIP version determines the AMI to use
[[ -n "$CAST_AIP_VERSION" ]]&& EXTRA_VARS="${EXTRA_VARS} cast_aip_version=$CAST_AIP_VERSION"

EXTRA_VARS="${EXTRA_VARS} aip_node_count=1" ./aws_aip.sh -i expand-aip-node.ini -i inventory.aws_ec2.yml --limit localhost "$@"
./aws_inventory.sh --graph
