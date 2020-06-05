#!/bin/bash
[[ -f $HOME/.aip-aws ]] && source "$HOME/.aip-aws"

# Win administrator password
[[ -n "$WIN_ADMIN_PASSWORD" ]] && EXTRA_VARS="${EXTRA_VARS} win_admin_password=$WIN_ADMIN_PASSWORD"

# CAIP version determines the AMI to use
[[ -n "$CAST_AIP_VERSION" ]]&& EXTRA_VARS="${EXTRA_VARS} cast_aip_version=$CAST_AIP_VERSION"

EXTRA_VARS="${EXTRA_VARS} aip_win_node_count=${COUNT:?"Give total count of windows worker nodes"}" ./aws_aip.sh -i expand-aip-win-nodes.ini  --limit localhost "$@" &&

EXTRA_VARS="${EXTRA_VARS}" ./aws_aip.sh -i inventory.aws_ec2.yml --limit aip_win_worker_node "$@" &&

./aws_inventory.sh --graph
