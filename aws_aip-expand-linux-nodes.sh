#!/bin/bash
[[ -f $HOME/.aip-aws ]] && source "$HOME/.aip-aws"

# Win administrator password
[[ -n "$WIN_ADMIN_PASSWORD" ]] && EXTRA_VARS="${EXTRA_VARS} win_admin_password=$WIN_ADMIN_PASSWORD"

# CAIP version determines the AMI to use
[[ -n "$CAST_AIP_VERSION" ]]&& EXTRA_VARS="${EXTRA_VARS} cast_aip_version=$CAST_AIP_VERSION"

# instance having the tag Swarm=swarm_token, query only the token
#aws ec2 describe-instances --filter "Name=tag:Swarm,Values=swarm_master" --query "Reservations[*].Instances[*].Tags[?Key=='Swarm_token'].{token:Value}

EXTRA_VARS="${EXTRA_VARS} aip_linux_node_count=2" ./aws_aip.sh -i expand-aip-linux-nodes.ini  --limit localhost "$@" &&

EXTRA_VARS="${EXTRA_VARS}" ./aws_aip.sh -i inventory.aws_ec2.yml --limit aip_linux_worker_node "$@" &&

./aws_inventory.sh --graph
