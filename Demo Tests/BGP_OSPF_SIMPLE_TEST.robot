*** Settings ***
Library	../lib/CloudShellAPILibrary.py  ${CloudShellAddress}	${User}	${AuthToken}	${Domain}	${sandbox.id}
Library	../lib/CloudShellRobotHelperLibrary.py	${sandbox}
Library	SSHLibrary
Library           String


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
    CloudShellAPILibrary.Write Sandbox Message    Starting Test..
    CloudShellAPILibrary.Set Sandbox Status    In Progress    Testing is in Progress
    Check BGP On All Devices

*** Keywords ***
Sleep for duration
    [Arguments]    ${duration}
    sleep    ${duration}s

Check BGP On All Devices
    Log    Health Checking all devices
    #CloudShellAPILibrary.Execute Blueprint Command    Health Check All Resources
    ${cisco} =    CloudShellAPILibrary.Get Resource By Resource Model Name    Cisco IOS Router 2G
    CloudShellAPILibrary.Write Sandbox Message    ${cisco}
    Check Cisco BGP Down    ${cisco}

Check Cisco BGP Down
    [Arguments]    ${device}
    Log    Configuring Cisco Router ${device.Name}
    SSHLibrary.Open Connection    ${device.FullAddress}
    Login    root    ${Cisco_Pass}
    Write    show ip bgp\n
    ${output} =    Read
    Run Keyword If    '{output}'!='${EMPTY}'
        Write    show ip bgp\n
        ${output} =    Read
    @{words} =    Split String    ${output}
    ${contains}=    Evaluate    "not" in """${words}"""
    # Should Be False    ${contains}
    Should Be Equal    ${contains}    ${TRUE}
    CloudShellAPILibrary.Write Sandbox Message    ${output}
    Close All Connections
