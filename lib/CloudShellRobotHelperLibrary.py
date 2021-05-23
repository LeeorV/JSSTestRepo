from cloudshell.api.cloudshell_api import CloudShellAPISession, InputNameValue
from uuid import UUID


class CloudShellRobotHelperLibrary(object):
    def __init__(self, sandbox_object: str):
        self.sandbox_object = sandbox_object
        self.sandbox_id = str(sandbox_object.id)

    def get_resource_by_model(self, resource_model):
        return next((resource for resource in self.sandbox_object.resources if resource_model in resource.model), "")

class ResourceDto():
    def __init__(self):
        self.name = str
        self.address = str
        self.full_address = str
        self.family = str
        self.model = str
        self.blueprint_alias = str
        self.connected_to = str