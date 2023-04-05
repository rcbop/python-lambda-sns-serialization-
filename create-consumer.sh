#!/bin/bash
ROLE_ARN=arn:aws:iam::000000000000:role/my-lambda-role
CONSUMER_QUEUE=arn:aws:sqs:us-east-1:000000000000:python-consumer-queue

PACKAGE=lambda-consumer-package.zip
FUNCTION_NAME=consumer

pushd consumer
trap popd EXIT

zip -vr $PACKAGE lambda_function.py ../common

awslocal lambda delete-function --function-name $FUNCTION_NAME || true

awslocal lambda create-function \
    --function-name $FUNCTION_NAME \
    --runtime python3.9 \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://$PACKAGE --role "$ROLE_ARN"

awslocal lambda create-event-source-mapping \
    --function-name consumer \
    --event-source-arn $CONSUMER_QUEUE \
    --batch-size 1 \
    --maximum-retry-attempts 0 \
    --starting-position LATEST
