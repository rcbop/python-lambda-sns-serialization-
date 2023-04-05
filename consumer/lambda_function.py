""" entrypoint of the lambda function """
import json
from common.message import Message, MessageEncoder


def lambda_handler(event, context):
    """ lambda being invoked by SQS queue to receive messages """
    # parse the message body from the event
    message_body = event["Records"][0]["body"]

    # deserialize the message body
    full_parsed_notification = json.loads(message_body, cls=MessageEncoder)
    parsed_message = Message(**full_parsed_notification["Message"])

    print("__repr__", parsed_message)


