#!/bin/bash
[[ -f $HOME/.aip-aws ]] && source "$HOME/.aip-aws"
EXTRA_VARS="$EXTRA_VARS" \
PLAYBOOK="provision/terminate_instance.yml" \
    ./aws_aip.sh  "$@"
