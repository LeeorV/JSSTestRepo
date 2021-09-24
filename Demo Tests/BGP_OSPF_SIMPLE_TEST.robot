*** Settings ***
Documentation     A test suite that performs the testing flow of the MSO Blueprint automatically.
Library           ../lib/CloudShellAPILibrary.py    ${CloudShellAddress}    ${User}    ${AuthToken}    ${Domain}    ${sandbox.id}
Library           ../lib/CloudShellRobotHelperLibrary.py    ${sandbox}
Library           SSHLibrary

*** Variables ***
${CloudShellAddress}    ${EMPTY}
${User}           ${EMPTY}
${Cisco_pass}     ${EMPTY}
${Juniper_pass}    ${EMPTY}
${AuthToken}      ${EMPTY}
${Domain}         Global
${duration}       5

*** Test Case ***
Perform SIMPLE OSPF CHECK
    CloudShellAPILibrary.Write Sandbox Message    Starting Test..
    CloudShellAPILibrary.Set Sandbox Status    In Progress    Testing is in Progress
    HealthCheck All Devices

*** Keywords ***
Sleep for duration
    [Arguments]    ${duration}
    sleep    ${duration}s

HealthCheck All Devices
    Log    Health Checking all devices
    CloudShellAPILibrary.Execute Blueprint Command    Health Check All Resources
    CloudShellAPILibrary.Write Sandbox Message    ${sandbox}
    ${cisco} =    Get Resource By Model    Cisco1801
    CloudShellAPILibrary.Write Sandbox Message    ${cisco}
    Configure Cisco    ${cisco}

Configure Cisco
    [Arguments]    ${device}
    Log    Configuring Cisco Router ${device.name}
    Open Connection    ${device.address}
    Login    cisco    ${Cisco_Pass}
    Write    show ip interface brief
    ${output} =    Read
    Log
    CloudShellAPILibrary.Write Sandbox Message    ${output}
    Close All Connections
