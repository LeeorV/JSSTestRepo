*** Settings ***
Library	../lib/CloudShellAPILibrary.py  ${CloudShellAddress}	${User}	${AuthToken}	${Domain}	${sandbox.id}
Library	../lib/CloudShellRobotHelperLibrary.py	${sandbox}
Library	SSHLibrary

Documentation     A test suite that performs the testing flow of the MSO Blueprint automatically.
*** Variables ***
${CloudShellAddress}             
${User}
${Cisco_pass}
${Juniper_pass}
${AuthToken}     
${Domain}                    Global
${duration}	5

*** Test Case ***
Perform SIMPLE OSPF CHECK
	CloudShellAPILibrary.Write Sandbox Message	Starting Test..
	CloudShellAPILibrary.Set Sandbox Status	In Progress	Testing is in Progress
	HealthCheck All Devices

*** Keywords ***
Sleep for duration
	[Arguments]	${duration}
	sleep	${duration}s

HealthCheck All Devices
	Log	Health Checking all devices
	CloudShellAPILibrary.Execute Blueprint Command	HealthCheck
	${cisco} =	Get Resource By Model	Cisco1801
	Configure Cisco	${cisco}

Configure Cisco
	[Arguments]	${device}
	Log	Configuring Cisco Router ${device.name}
	Open Connection	${device.address}
	Login	cisco	${Cisco_Pass}
	Write	show ip interface brief
	${output} =	Read
	Log
	CloudShellAPILibrary.Write Sandbox Message    ${output}
	Close All Connections

