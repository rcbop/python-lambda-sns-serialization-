""" common package """
import json
import dataclasses
from dataclasses import dataclass
from datetime import datetime
from enum import Enum


class MessageType(Enum):
    """ MessageType enum """
    INFO = "INFO"
    ERROR = "ERROR"


@dataclass
class Message:
    """ Message class """
    message: str
    timestamp: datetime
    message_type: MessageType


class MessageDecoder(json.JSONEncoder):
    """ MessageDecoder class """

    def default(self, o):
        if isinstance(o, datetime):
            return {"__datetime__": o.isoformat()}
        if isinstance(o, MessageType):
            return {"__type__": o.value}
        if isinstance(o, Message):
            return dataclasses.asdict(o)
        return json.JSONEncoder.default(self, o)


class MessageEncoder(json.JSONDecoder):
    """ MessageEncoder class """

    def __init__(self):
        json.JSONDecoder.__init__(self, object_hook=self.dict_to_object)

    def dict_to_object(self, d):
        if "__datetime__" in d:
            return datetime.fromisoformat(d["__datetime__"])
        if "__type__" in d:
            return MessageType(d["__type__"])
        if isinstance(d, Message):
            return Message(**d)
        return d
