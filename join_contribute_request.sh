#!/bin/bash

set -e

cash=$(cat $1)
ideal=$(cat $2)

#jq '[.[] | {current: $portfolio, ideal: $ideal}]'
echo "{"
echo -n "\"cash\":"
echo $cash 
echo ","
echo -n "\"ideal\":"
echo $ideal
echo "}"

