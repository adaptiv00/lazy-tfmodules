#!/usr/bin/env bash

FULL_ERASE=${FULL_ERASE:-"no"}
STACK_NAMES=${STACK_NAMES:-""}
DEPLOY_FOLDER=${DEPLOY_FOLDER:-""}

for STACK in $STACK_NAMES; do
  docker stack rm $STACK
done

for STACK in $STACK_NAMES; do
  docker stack deploy $STACK -c $DEPLOY_FOLDER/swarm/$STACK.yml
done