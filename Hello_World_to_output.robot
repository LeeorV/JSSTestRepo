*** Settings ***
Library           lib/CloudShellAPILibrary.py  ${CloudShellAddress}  ${User}  ${AuthToken}  ${Domain}

Documentation     A test suite containing one test that sleeps for a while.
...		  The suite should pass successfully.

*** Variables ***
${CloudShellAddress}             
${User}
${AuthToken}     
${Domain}                    Demo Advanced
${duration}	5

*** Test Case ***
Hello World with Delay
	Print	Hello World!
	Print to Sandbox	${sandbox.id}	Hello World
	Sleep for duration	${duration}

*** Keywords ***
Print
	[Arguments]	${text}
	Log	${text}

Print to Sandbox
	[Arguments]	${sandbox_id}	${message}
	Write Message	${sandbox_id}	${message}

Sleep for duration
	[Arguments]	${duration}
	sleep	${duration}s
