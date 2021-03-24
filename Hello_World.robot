*** Settings ***
Documentation     A test suite containing one test that sleeps for a while.
...				  The suite should pass successfully.

*** Variables ***
${duration}			5

*** Test Case ***
Sleep for a while
	Sleep for	   ${duration}
  print Hello World!
  print sandbox id      ${sandbox.id}



*** Keywords ***
Sleep for
	[Arguments]    ${duration}
	sleep 		   ${duration}s
