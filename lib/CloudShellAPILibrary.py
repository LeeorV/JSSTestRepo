import logging
import requests
import json
import time
from cloudshell.api.cloudshell_api import CloudShellAPISession
from robot.api import logger


class CloudShellAPILibrary(object):
    def __init__(self, cloudshell_address, user="admin", auth_token='', domain="Global"):
        self.api_session = CloudShellAPISession(cloudshell_address, user, token_id=auth_token, domain=domain)

    def write_message(self, sandbox_id : str, message):
        #self.api_session.WriteMessageToReservationOutput(str(sandbox_id), message)
        print(f"Sandbox ID:{sandbox_id}, message:{message}")