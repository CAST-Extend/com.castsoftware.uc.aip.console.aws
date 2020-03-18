#!/bin/bash
# Debian Stretch (9.7), Ubuntu bionic (18.04) and CentOS (7) supported only
# Check for working directory (vagrant provision)
[[ -f $HOME/.aip-aws ]] && source "$HOME/.aip-aws"
[[ -n "$s3_BUCKET" ]] && EXTRA_VARS="$EXTRA_VARS cast_aip_s3_bucket=$s3_BUCKET"
[[ -n "$CAST_AIP_VERSION" ]]&& EXTRA_VARS="$EXTRA_VARS cast_aip_version=$CAST_AIP_VERSION"
EXTRA_VARS="$EXTRA_VARS" \
PLAYBOOK="provision/terminate_instance.yml" \
    ./aws_aip.sh -i inventory.terminate.aws_ec2.yml "$@"
