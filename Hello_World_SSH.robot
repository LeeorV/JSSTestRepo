*** Settings ***
Documentation     A test suite containing one test that sleeps for a while.
...		  The suite should pass successfully.
Library	SSHLibrary

*** Variables ***
${duration}	5

*** Test Case ***
Hello World with Delay
	Open Connection	192.168.42.238
	Login	root	qs1234
	${output} =	Execute Command	echo hello world!
	Log	${output}
	${output} =	Execute Command	ls
	Log	${output}
	Close All Connections

*** Keywords ***
Print
	[Arguments]	${text}
	Log		${text}

Sleep for duration
	[Arguments]	${duration}
	sleep		${duration}s
