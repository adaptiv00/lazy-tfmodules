#!/usr/bin/env bash

# Terraform cannot read complex structures directly from external data sources
# So we base64 encode, and then jsondecode(base64decode) and it seems to work
DIR=$(dirname "$0")
SCRIPTPATH="$( cd "$DIR" ; pwd -P )"
"$SCRIPTPATH"/lazy-topology
echo "{\"topology\":\"$( cat deploy/topology.json | base64 )\"}"
