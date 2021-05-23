*** Settings ***
Library	../lib/CloudShellAPILibrary.py  ${CloudShellAddress}	${User}	${AuthToken}	${Domain}	${sandbox.id}
Library	../lib/CloudShellRobotHelperLibrary.py	${sandbox}
Library SSHLibrary

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
	${output} =	Execute Command	show ip interface brief
	Log ${output}
	${output} =	Execute Command	show interfaces description
	Log ${output}
	${output} =	Execute Command	show hosts
	Log ${output}
	Execute Command	configure terminal
	Execute Command	ip host ciena3916 2049 192.168.1.1
	Execute Command	end
	Execute Command	write memory
	${output} =	Execute Command	show hosts
	Log ${output}
	Close All Connections

Configure Ciena
	[Arguments]	${device}
	Log	Configuring Ciena CPE ${device.name}
	Open Connection	${device.address}
	Login	su	${Ciena_Pass}
	Execute Command	vlan create vlan 10
	Execute Command	vlan add vlan 10 port 2
	Execute Command	vlan add vlan 10 port 3
	Execute Command	vlan add vlan 10 port 6
	Execute Command	vlan create vlan 100
	Execute Command	vlan add vlan 100 port 4 
	${output} =	Execute Command	vlan show
	Log ${output}
	${output} =	Execute Command	port show port 2 statistics
	Log ${output}
	Execute Command	port clear port 2 statistics
	${output} =	Execute Command	port show port 2 statistics
	Log ${output}
	Execute Command	configuration save
	Close All Connections

Configure Juniper
	[Arguments]	${device}
	Log	Configuring Juniper Router ${device.name}
	Open Connection	${device.address}
	Login	juniper	${Juniper_pass}
	Execute Command	configure
	Execute Command	set system root-authentication plain-text-password newpassword
	Execute Command	set system host-name JuniperEX4200-01
	Execute Command	set system domain-name example.com
	Execute Command	set system backup-router 10.0.0.1
	Execute Command	set routing-options static route default nexthop 10.0.0.1 retain no-readvertise
	${output} =	Execute Command	commit
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
