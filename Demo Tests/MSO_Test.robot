*** Settings ***
Library	../lib/CloudShellAPILibrary.py  ${CloudShellAddress}	${User}	${AuthToken}	${Domain}	${sandbox.id}
Library	../lib/CloudShellRobotHelperLibrary.py	${sandbox}
Library	SSHLibrary

Documentation     A test suite that performs the testing flow of the MSO Blueprint automatically.

*** Variables ***
${CloudShellAddress}             
${User}
${Cisco_pass}
${Ciena_pass}
${Juniper_pass}
${AuthToken}     
${Domain}                    Global
${duration}	5

*** Test Case ***
Perform MSO Flow
	CloudShellAPILibrary.Write Sandbox Message	Starting Test..
	CloudShellAPILibrary.Set Sandbox Status	In Progress	Testing is in Progress
	HealthCheck All Devices
	${cisco} =	Get Resource By Model	Cisco CRS1
	Configure Cisco	${cisco}
	${ciena} =	Get Resource By Model	Ciena 3916
	Configure Ciena	${ciena}
	${Juniper} =	Get Resource By Model	MX960
	Configure Juniper	${Juniper}
	Start Ixia Traffic
	Sleep for duration	60
	Stop Ixia Traffic

*** Keywords ***
Sleep for duration
	[Arguments]	${duration}
	sleep	${duration}s

HealthCheck All Devices
	Log	Health Checking all devices
	CloudShellAPILibrary.Execute Blueprint Command	HealthCheck

Configure Cisco
	[Arguments]	${device}
	Log	Configuring Cisco Router ${device.name}
	Open Connection	${device.address}
	Login	cisco	${Cisco_Pass}
	${output} =	SSHLibrary.Execute Command	show ip interface brief
	Log ${output}
	${output} =	SSHLibrary.Execute Command	show interfaces description
	Log ${output}
	${output} =	SSHLibrary.Execute Command	show hosts
	Log ${output}
	SSHLibrary.Execute Command	configure terminal
	SSHLibrary.Execute Command	ip host ciena3916 2049 192.168.1.1
	SSHLibrary.Execute Command	end
	SSHLibrary.Execute Command	write memory
	${output} =	SSHLibrary.Execute Command	show hosts
	Log ${output}
	Close All Connections

Configure Ciena
	[Arguments]	${device}
	Log	Configuring Ciena CPE ${device.name}
	Open Connection	${device.address}
	Login	su	${Ciena_Pass}
	SSHLibrary.Execute Command	vlan create vlan 10
	SSHLibrary.Execute Command	vlan add vlan 10 port 2
	SSHLibrary.Execute Command	vlan add vlan 10 port 3
	SSHLibrary.Execute Command	vlan add vlan 10 port 6
	SSHLibrary.Execute Command	vlan create vlan 100
	SSHLibrary.Execute Command	vlan add vlan 100 port 4 
	${output} =	SSHLibrary.Execute Command	vlan show
	Log ${output}
	${output} =	SSHLibrary.Execute Command	port show port 2 statistics
	Log ${output}
	SSHLibrary.Execute Command	port clear port 2 statistics
	${output} =	SSHLibrary.Execute Command	port show port 2 statistics
	Log ${output}
	SSHLibrary.Execute Command	configuration save
	Close All Connections

Configure Juniper
	[Arguments]	${device}
	Log	Configuring Juniper Router ${device.name}
	Open Connection	${device.address}
	Login	juniper	${Juniper_pass}
	SSHLibrary.Execute Command	configure
	SSHLibrary.Execute Command	set system root-authentication plain-text-password newpassword
	SSHLibrary.Execute Command	set system host-name JuniperEX4200-01
	SSHLibrary.Execute Command	set system domain-name example.com
	SSHLibrary.Execute Command	set system backup-router 10.0.0.1
	SSHLibrary.Execute Command	set routing-options static route default nexthop 10.0.0.1 retain no-readvertise
	${output} =	SSHLibrary.Execute Command	commit
	Log ${output}
	Close All Connections

Start Ixia Traffic
	Log	Starting Ixia Traffic
	CloudShellAPILibrary.Write Sandbox Message	Starting Traffic...
	CloudShellAPILibrary.Set Sandbox Status	In Progress	Running Ixia Traffic
	CloudShellAPILibrary.Execute Command	TGN-01	Resource	IxiaStartTraffic

Stop Ixia Traffic
	Log	Stopping Ixia Traffic
	CloudShellAPILibrary.Execute Command	TGN-01	Resource	IxiaStopTraffic
	${stats} = 	CloudShellAPILibrary.Execute Command	TGN-01	Resource	IxiaGetStatistics
	Log	${stats}
	CloudShellAPILibrary.Set Sandbox Status	Completed successfully	Traffic Run completed successfully
