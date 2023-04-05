#!/bin/bash
#
# This script creates the following resources:
# - SNS topic
# - SQS queue
# - SNS subscription
# - IAM role
# - IAM policy
#
# To be run after localstack is started.
#
TOPIC_NAME="fanout-topic"
TOPIC_ARN="arn:aws:sns:us-east-1:000000000000:${TOPIC_NAME}"
PYTHON_QUEUE_NAME="python-consumer-queue"
PYTHON_QUEUE_ARN="arn:aws:sqs:us-east-1:000000000000:${PYTHON_QUEUE_NAME}"
LAMBDA_ROLE_NAME="my-lambda-role"

awslocal sns create-topic --name "${TOPIC_NAME}"

awslocal sqs create-queue --queue-name "${PYTHON_QUEUE_NAME}"
awslocal sns subscribe --topic-arn "${TOPIC_ARN}"  \
    --protocol sqs \
    --notification-endpoint ${PYTHON_QUEUE_ARN}

awslocal iam create-role \
    --role-name ${LAMBDA_ROLE_NAME} \
    --assume-role-policy-document '{"Version": "2012-10-17", "Statement": [{"Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]}'

awslocal iam create-policy \
    --policy-name my-lambda-policy \
    --policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":["sqs:ReceiveMessage"],"Resource":"arn:aws:sqs:us-east-1:000000000000:my-queue"}]}'
