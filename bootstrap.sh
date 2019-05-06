#!/bin/bash
#TODO:
# check errors on expand.
# when running twice, the expand process does return an error as no host matches a play
./aws_aip-expand.sh && ./aws_aip-postgres.sh && ./aws_aip-node.sh && ./aws_aip-dashboard.sh && ./aws_aip-console.sh
