*** Settings ***
Library           ../lib/CloudShellAPILibrary.py  ${CloudShellAddress}	${User}	${AuthToken}	${Domain}	${sandbox.id}

Documentation     A test suite containing one test that sleeps for a while.
...		  The suite should pass successfully.

*** Variables ***
${CloudShellAddress}             
${User}
${AuthToken}     
${Domain}                    Global
${duration}	5

*** Test Case ***
Perform MSO Flow
	CloudShellAPILibrary.Write Sandbox Message	Starting Test..
	CloudShellAPILibrary.Set Sandbox Status	In Progress	Testing is in Progress
	HealthCheck All Devices
	Start Ixia Traffic
	Sleep for duration	60
	Stop Ixia Traffic

*** Keywords ***
Sleep for duration
	[Arguments]	${duration}
	sleep	${duration}s

HealthCheck All Devices
	Log	Health Checking all devices
	CloudShellAPILibrary.Execute Blueprint Command	HealthCheck

Start Ixia Traffic
	Log	Starting Ixia Traffic
	CloudShellAPILibrary.Write Sandbox Message	Starting Traffic...
	CloudShellAPILibrary.Set Sandbox Status	In Progress	Running Ixia Traffic
	CloudShellAPILibrary.Execute Command	TGN-01	Resource	IxiaStartTraffic

Stop Ixia Traffic
	Log	Stopping Ixia Traffic
	CloudShellAPILibrary.Execute Command	TGN-01	Resource	IxiaStopTraffic
	${stats} = 	CloudShellAPILibrary.Execute Command	TGN-01	Resource	IxiaGetStatistics
	Log ${stats}
	CloudShellAPILibrary.Set Sandbox Status	Completed successfully	Traffic Run completed successfully
