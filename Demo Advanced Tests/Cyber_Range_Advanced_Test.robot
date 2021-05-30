*** Settings ***
Library	../lib/CloudShellAPILibrary.py  ${CloudShellAddress}	${User}	${AuthToken}	${Domain}	${sandbox.id}
Library	../lib/CloudShellRobotHelperLibrary.py	${sandbox}
Library	SSHLibrary

Documentation     A test suite that automates the execution flow of the Cyber Range Adv. Blueprint

*** Variables ***
${CloudShellAddress}             
${User}
${Juniper_pass}
${AuthToken}     
${Domain}                    Demo Advanced
${duration}	5

*** Test Case ***
Perform MSO Flow
	CloudShellAPILibrary.Write Sandbox Message			Starting Test..
	CloudShellAPILibrary.Set Sandbox Status				In Progress	Testing is in Progress
	CloudShellAPILibrary.Execute Blueprint Command		CyberRangeDeploy
	CloudShellAPILibrary.Execute Blueprint Command		PowerOn
	CloudShellAPILibrary.Execute Blueprint Command		HealthCheck
	${Juniper} =										Get Resource By Model	MX480
	Configure Juniper									${Juniper}

	Start BreakingPoint Attack Traffic
	CloudShellAPILibrary.Execute Command	Snort-05	Resource	IDSStartDetection
	Sleep for duration	60
	CloudShellAPILibrary.Execute Command	Malware Analyzer 05	Resource	  MalwareAnalysisCreateAnalysisReport
	CloudShellAPILibrary.Execute Command	Snort-05	Resource	IDSStopDetection
	Stop BreakingPoint Attack Traffic

*** Keywords ***
Sleep for duration
	[Arguments]	${duration}
	sleep	${duration}s

Configure Juniper
	[Arguments]	${device}
	Log	Configuring Juniper Router ${device.name}
	Open Connection	${device.address}
	Login	juniper	${Juniper_pass}
	Write	configure
	Write	set system root-authentication plain-text-password newpassword
	Write	set system host-name JuniperEX4200-01
	Write	set system domain-name example.com
	Write	set system backup-router 10.0.0.1
	Write	set routing-options static route default nexthop 10.0.0.1 retain no-readvertise
	Write	commit
	${output} =	Read
	Log	${output}
	Close All Connections

Start BreakingPoint Attack Traffic
	Log	Starting BreakingPoint Traffic
	CloudShellAPILibrary.Write Sandbox Message	Starting Traffic...
	CloudShellAPILibrary.Set Sandbox Status	In Progress	BreakingPoint Traffic
	CloudShellAPILibrary.Execute Command	BreakingPoint VE-05		Resource	IxiaStartAttack

Stop BreakingPoint Attack Traffic
	Log	Stopping BreakingPoint Traffic
	CloudShellAPILibrary.Execute Command	BreakingPoint VE-05		Resource	IxiaStopTraffic
	CloudShellAPILibrary.Set Sandbox Status	Completed successfully	Traffic Run completed successfully
