*** Settings ***
Documentation     A test suite containing one test that sleeps for a while.
...		  The suite should pass successfully.

*** Variables ***
${duration}	5

*** Test Case ***
Hello World with Delay
	Print	Hello World!
	Sleep	${duration}


*** Keywords ***
Print
	[Arguments]	${text}
	Log		${text}

Sleep
	[Arguments]	${duration}
	sleep		${duration}s
