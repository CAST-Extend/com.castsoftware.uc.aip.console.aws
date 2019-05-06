#!/bin/bash
[[ -f $HOME/.aip-aws ]] && source "$HOME/.aip-aws"
[[ -n "$s3_BUCKET" ]] && EXTRA_VARS="cast_aip_s3_bucket=$s3_BUCKET"
[[ -n "$CAST_AIP_CONSOLE_VERSION" ]] && EXTRA_VARS="$EXTRA_VARS cast_aip_console_version=$CAST_AIP_CONSOLE_VERSION"
[[ -n "$CAST_AIP_CONSOLE_BUILD_NUMBER" ]] && EXTRA_VARS="$EXTRA_VARS cast_aip_console_build_number=$CAST_AIP_CONSOLE_BUILD_NUMBER"
EXTRA_VARS="$EXTRA_VARS" \
    ./aws_aip.sh -i inventory.aws_ec2.yml --limit "aip_console_hosts:&expand" "$@"
