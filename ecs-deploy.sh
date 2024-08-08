#!/bin/bash

REGION=$1
CLUSTER=$2
SERVICE=$3
ROLLBACK=$4
TIMEOUT=$5

if [ "$ROLLBACK" = "--rollback" ]; then
  aws ecs update-service --region $REGION --cluster $CLUSTER --service $SERVICE --force-new-deployment
else
  IMAGE=$6
  aws ecs update-service --region $REGION --cluster $CLUSTER --service $SERVICE --force-new-deployment --desired-count 0
  sleep 10
  aws ecs update-service --region $REGION --cluster $CLUSTER --service $SERVICE --force-new-deployment --desired-count 1 --task-definition $IMAGE
fi

# Optionally add a timeout and wait for deployment stabilization
if [ -n "$TIMEOUT" ]; then
  aws ecs wait services-stable --region $REGION --cluster $CLUSTER --services $SERVICE --timeout $TIMEOUT
fi
