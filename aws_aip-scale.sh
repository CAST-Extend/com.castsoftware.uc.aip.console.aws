#!/bin/bash
aip_node_count=${1?"Missing node count"}
! [[ $aip_node_count  =~ ^[0-9]+$ ]] && echo "$0 <count: integer>" && exit 1
aip_node_count=$aip_node_count ./aws_aip-expand.sh -t aipnode &&
./aws_aip-node.sh &&
./aws_aip-console.sh -t aipnode -vv
