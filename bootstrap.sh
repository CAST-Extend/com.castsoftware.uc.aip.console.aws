#!/bin/bash
./aws_aip-expand.sh && ./aws_aip-postgres.sh && ./aws_aip-node.sh && ./aws_aip-dashboard.sh && ./aws_aip-console.sh
