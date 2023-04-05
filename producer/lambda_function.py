""" entrypoint of the lambda function """
import json
import os
import random
from datetime import datetime

import boto3

from common.message import Message, MessageDecoder, MessageType

sns_topic_arn: str = os.environ.get("TOPIC_ARN")
localstack_hostname: str = os.environ.get("LOCALSTACK_HOSTNAME", None)
edge_port: str = os.environ.get("EDGE_PORT", "4566")

if localstack_hostname is None:
    endpoint_url = None
else:
    endpoint_url: str = f"http://{localstack_hostname}:{edge_port}"

sns_client: boto3.client = boto3.client("sns", endpoint_url=endpoint_url)

def lambda_handler(event, context):
    """ lambda producer handler """
    message_type = [MessageType.INFO, MessageType.ERROR][random.randint(0, 1)]
    message = Message(
        message=f"this is a random number {random.randint(1, 100)}",
        timestamp=datetime.now(),
        message_type=message_type
    )
    serialized_message=json.dumps({"default": message}, cls=MessageDecoder)
    print("publishing message to topic", sns_topic_arn)
    print("using endpoint", endpoint_url)
    sns_client.publish(
        TopicArn=sns_topic_arn,
        Message=serialized_message,
        MessageStructure="json")
    return serialized_message
