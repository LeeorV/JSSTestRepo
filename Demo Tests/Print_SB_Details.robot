*** Settings ***
Documentation     A test suite containing one test that sleeps for a while.
...		  The suite should pass successfully.

*** Variables ***
${duration}	5

*** Test Case ***
Hello World with Delay
	Print	${sandbox.resources}

*** Keywords ***
Print
	[Arguments]	${text}
	Log		${text}