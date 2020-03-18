#!/bin/bash
#
# BAKE Linux registry with aip console image
# All required artifacts MUST be uploaded to s3
#
# shellcheck source=/dev/null
[[ -f $HOME/.aip-aws ]] && source "$HOME/.aip-aws"
[[ -n "$s3_BUCKET" ]] && EXTRA_VARS="$EXTRA_VARS cast_aip_s3_bucket=$s3_BUCKET"
[[ -n "$CAST_AIP_VERSION" ]]&& EXTRA_VARS="$EXTRA_VARS cast_aip_version=$CAST_AIP_VERSION"

EXTRA_VARS="$EXTRA_VARS" \
PLAYBOOK="provision/bake.yml" \
    ./aws_aip.sh -i bake-aip-linux-registry.ini "$@"
