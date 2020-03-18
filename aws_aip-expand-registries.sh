#!/bin/bash
[[ -f $HOME/.aip-aws ]] && source "$HOME/.aip-aws"

# Win administrator password
[[ -n "$WIN_ADMIN_PASSWORD" ]] && EXTRA_VARS="${EXTRA_VARS} win_admin_password=$WIN_ADMIN_PASSWORD"

# CAIP version determines the AMI to use
[[ -n "$CAST_AIP_VERSION" ]]&& EXTRA_VARS="${EXTRA_VARS} cast_aip_version=$CAST_AIP_VERSION"

EXTRA_VARS="${EXTRA_VARS}" ./aws_aip.sh -i expand-aip-registries.ini  --limit localhost "$@"
./aws_inventory.sh --graph
