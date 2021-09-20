*** Settings ***
Library	../lib/CloudShellAPILibrary.py  ${CloudShellAddress}	${User}	${AuthToken}	${Domain}	${sandbox.id}
Library	../lib/CloudShellRobotHelperLibrary.py	${sandbox}
Library	SSHLibrary

Documentation     A test suite that performs the testing flow of the MSO Blueprint automatically.
*** Variables ***
${CloudShellAddress}             
${User}
${Cisco_pass}
${Ciena_pass}
${Juniper_pass}
${AuthToken}     
${Domain}                    Global
${duration}	5

*** Test Case ***
Perform SIMPLE OSPF CHECK
