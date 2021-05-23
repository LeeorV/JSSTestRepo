*** Settings ***
Documentation     A test suite containing one test that sleeps for a while.
...		  The suite should pass successfully.
Library	../lib/CloudShellRobotHelperLibrary.py	${sandbox}

*** Variables ***
${duration}	5

*** Test Case ***
Print Sandbox Resources
	${cisco} =	Get Resource By Model	Cisco CRS1
	print ${cisco}
	${Juniper} =	Get Resource By Model	MX960
	print ${Juniper}
	${ciena} =	Get Resource By Model	Ciena 3916
	print ${ciena}

	Print	${sandbox.resources}

*** Keywords ***
Print
	[Arguments]	${text}
	Log		${text}