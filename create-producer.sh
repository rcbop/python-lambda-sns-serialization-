#!/bin/bash
ROLE_ARN="arn:aws:iam::000000000000:role/my-lambda-role"
TOPIC_ARN="arn:aws:sns:us-east-1:000000000000:fanout-topic"

PACKAGE="lambda-producer-package.zip"
FUNCTION_NAME="producer"

pushd producer
trap popd EXIT

zip -vr $PACKAGE lambda_function.py ../common

awslocal lambda delete-function --function-name $FUNCTION_NAME || true

awslocal lambda create-function \
    --function-name $FUNCTION_NAME \
    --runtime python3.9 \
    --handler lambda_function.lambda_handler \
    --environment Variables="{TOPIC_ARN=$TOPIC_ARN}" \
    --zip-file fileb://$PACKAGE --role "$ROLE_ARN"
