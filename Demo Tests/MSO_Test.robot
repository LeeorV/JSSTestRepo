*** Settings ***
Library           ../lib/CloudShellAPILibrary.py  ${CloudShellAddress}  ${User}  ${AuthToken}  ${Domain} ${sandbox.id}

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
	HealthCheck All Devices
	Start Ixia Traffic
	MSO_Test.Sleep for duration  10
	Stop Ixia Traffic
	CloudShellAPILibrary.Write Message	Hello World from the Sandbox Output
	#${value} =	Execute Command ${router}  run_custom_command  ${params}


*** Keywords ***
Sleep for duration
	[Arguments]	${duration}
	sleep	${duration}s

HealthCheck All Devices
	CloudShellAPILibrary.Execute Blueprint Command	HealthCheck

Start Ixia Traffic
	Log	Starting Ixia Traffic

Stop Ixia Traffic
	Log	Stopping Ixia Traffic
