#!/bin/bash
# shellcheck source=/dev/null
[[ -f $HOME/.aip-aws ]] && source "$HOME/.aip-aws"
WIN_ADMIN_PASSWORD=${WIN_ADMIN_PASSWORD:?"Missing Windows Administrator password"}
EXTRA_VARS="win_admin_password=$WIN_ADMIN_PASSWORD"
[[ -n "$s3_BUCKET" ]] && EXTRA_VARS="$EXTRA_VARS cast_aip_s3_bucket=$s3_BUCKET"
[[ -n "$CAST_AIP_VERSION" ]]&& EXTRA_VARS="$EXTRA_VARS cast_aip_version=$CAST_AIP_VERSION"

#EXTRA_VARS="$EXTRA_VARS" \
#    ./aws_aip.sh -i inventory.aws_ec2.yml --limit "aip_node_hosts:&expand" "$@"
EXTRA_VARS="$EXTRA_VARS" \
PLAYBOOK="provision/node_bake.yml" \
    ./aws_aip.sh "$@"
