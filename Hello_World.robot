*** Settings ***
Documentation     A test suite containing one test that sleeps for a while.
...		  The suite should pass successfully.

*** Variables ***
${duration}	5

*** Test Case ***
Hello World with Delay
	Print	Hello World!
	Sleep for duration	${duration}


*** Keywords ***
Print
	[Arguments]	${text}
	Log		${text}

Sleep for duration
	[Arguments]	${duration}
	sleep		${duration}s
