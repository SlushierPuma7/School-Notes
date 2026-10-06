# Network Design, Configuration, and Protocols Study Guide

## 1. Device Maintenance & Switch Password Recovery

To reset a Cisco 3750 series switch and bypass forgotten privileged passwords, physical access and terminal access via PuTTY are required.

* Recovery Steps:
  1. Unplug the power cord, hold the switch MODE button, and restore power while holding the button until the SYSTEM LED turns solid green or the switch: prompt appears.
  2. Initialize flash memory using flash_init and view directory files with dir flash.
  3. Rename the configuration file from flash:config.text to flash:config.old and issue the boot command.
  4. Decline the initial configuration prompt ("no") to reach the EXEC prompt. Enter privileged EXEC mode (enable), rename the old configuration back using rename flash:config.old flash:config.text, and load it into RAM using copy flash:config.text system:running-config.
  5. Re-configure passwords under configure terminal.
* Password Command Distinction:
  * enable password: Sets the basic password for accessing privileged EXEC mode on the switch itself.
  * enable secret: Sets an encrypted secret password used when running enable. To remove a secret password that cannot be left blank, use the command no enable secret.
  * Save configurations using write memory.

## 2. Hierarchical Network Design Model

Enterprise and campus networks are organized into a multi-tier architecture to structure bandwidth, management, and routing functionality.

| Network Layer	| Primary Function	| Devices & Technologies	| OSI Layer Scope |
| --- | --- | --- | --- |
| Access (Edge) Layer |	Connects end-stations and client nodes (desktops, laptops, printers, IP phones, wireless APs) to the network.	| Commodity switches, Wireless Access Points (APs).	| Layer 2 (VLANs, Access Ports) |
| Distribution Layer | The "smart layer." Controls network routing, inter-VLAN communication, security filtering (internal firewalls), QoS policies, and branch-office WAN connectivity.	| Multi-Layer Switches (MLS), Layer 3 Switches.	| Layer 3 (Routing, IP Addressing) |
| Core Layer | The network backbone. Provides high-speed, highly redundant forwarding services to move traffic rapidly between distribution devices across different regions (10, 40, 100 Gbps).	| High-speed chassis-based switches, core switches.	| Layer 2 (Fast switching, minimal config) |
| Border Layer | Connects the enterprise network to external networks such as the Internet or service providers.	| Border Routers, Firewalls, Load Balancers, Border IPS.	| Layer 3 and above |

## 3. IP Addressing, Subnetting, and VLSM Design

Subnetting divides network blocks based on required host counts using variable-length subnet masks (VLSM). Usable IP addresses are calculated as 2^n - 2, where n represents the number of host bits.

| Prefix (CIDR)	| Subnet Mask	| Host Bits (n)	| Total IP Count (2^n)	| Usable IP Count (2^n - 2)	| 3rd Octet Increment |
| --- | --- | --- | --- | --- | --- |
| /21	| 255.255.248.0	| 11 | 2048	| 2046	| 8 |
| /22	| 255.255.252.0	| 10 | 1024	| 1022	| 4 |
| /23	| 255.255.254.0	| 9	| 512	| 510	| 2 |
| /24	| 255.255.255.0	| 8	| 256	| 254	| 1 |
| /25	| 255.255.255.128	| 7	| 128	| 126	| N/A (4th Octet: 128) |
| /26	| 255.255.255.192	| 6	| 64	| 62	| N/A (4th Octet: 64) |
| /27	| 255.255.255.224	| 5	| 32	| 30	| N/A (4th Octet: 32) |
| /28	| 255.255.255.240	| 4	| 16	| 14	| N/A (4th Octet: 16) |
| /29	| 255.255.255.248	| 3	| 8	| 6	| N/A (4th Octet: 8) |
| /30	| 255.255.255.252	| 2	| 4	| 2	| N/A (4th Octet: 4) |

Sample VLAN Subnet Allocation

* Management (VLAN 1): 250 Hosts needed \rightarrow /24 (10.9.15.1 – 10.9.15.254)
* FacStaff (VLAN 100): 200 Hosts needed \rightarrow /24 (10.9.14.1 – 10.9.14.254)
* Student (VLAN 110): 450 Hosts needed \rightarrow /23 (10.9.12.1 – 10.9.13.254)
* StuLab1 (VLAN 130): 35 Hosts needed \rightarrow /26 (10.9.16.129 – 10.9.16.192)
* StuLab2 (VLAN 140): 65 Hosts needed \rightarrow /25 (10.9.16.1 – 10.9.16.126)
* StuWireless (VLAN 200): 1024 Hosts needed \rightarrow /21 (10.9.0.1 – 10.9.7.254)
* FSWireless (VLAN 210): 650 Hosts needed \rightarrow /22 (10.9.8.1 – 10.9.11.254)

## 4. Dynamic Host Configuration Protocol (DHCP)

DHCP automates the assignment of IP addresses, subnet masks, default gateways, and DNS configuration parameters.

Operational Protocol Architecture

* Transport Model: Connectionless service using UDP.
  * Server Port: 67
  * Client Port: 68
* Initialization (DORA Process):
  1. Discover: Client broadcasts a packet to locate available DHCP servers.
  2. Offer: Server responds with a unicast/broadcast offer containing an IP address lease.
  3. Request: Client requests the offered IP lease from the server.
  4. Acknowledgement (ACK): Server confirms the IP lease acceptance.
* Why Request and ACK are Necessary: When multiple redundant DHCP servers exist on a network, the Request phase confirms which server's offer the client chooses, allowing other servers to release their reserved offers. It also prevents IP pool exhaustion caused by rogue Discover packets.
* Lease Timers & Phases:
  * Renewal: Begins at 50% of the lease duration. Client sends unicast DHCP Request packets directly to the leasing server.
  * Rebinding: Triggers if renewal fails by 87.5% of lease duration. Client broadcasts DHCP Request packets to any reachable DHCP server.
  * Expiration: If no server acknowledges before the lease time hits 100%, the IP address is released, TCP/IP traffic stops, and the client must restart DORA.

DHCP Wireshark Analysis Findings

A packet capture may display 8 packets instead of 4 during lease request cycles if dual DHCP servers (e.g., 192.171.155.254 and 192.171.155.253) are active on the subnet. In this scenario, two separate Offers and two ACKs are captured alongside initial Release and Request packets.

Key DHCP Packet Header Fields

* Operation Code: Identifies whether the message is a request or reply.
* Transaction ID: Randomly generated number used to pair requests and replies over connectionless UDP.
* Client IP Address (CIAddr): Client's existing IP address.
* "Your" IP Address (YIAddr): Offered/assigned IP address from the server.
* Server IP Address (SIAddr): IP address of the responding DHCP server.
* Gateway IP Address (GIAddr): IP address of the default gateway or relay agent.
* Client Hardware Address (CHAddr): Client MAC address.

Cisco Switch Configuration & DHCP Relay

Routers and Layer 3 switches drop Layer 2 broadcast packets by default. To allow clients on separate VLANs to reach a central DHCP server across subnets, a relay agent must be configured using the ip helper-address command.
```
! Enabling Routing & Default Interfaces on Cisco Switches
enable
configure terminal
ip routing                           ! Enables IP routing on a Multilayer Switch

interface vlan 1
 ip address 10.9.15.1 255.255.255.0
 no shutdown                         ! VLAN 1 is shut down by default on switches

! Setting up DHCP Relay across User VLANs
interface vlan 100
 ip helper-address 10.9.15.2         ! Converts DHCP broadcasts to unicasts sent to server 10.9.15.2
 exit
interface vlan 110
 ip helper-address 10.9.15.2
 exit
```

Note on Packet Tracer DHCP Pools: The default serverPool on a server serves the local subnet (e.g., VLAN 1), cannot be deleted, and must be edited directly. Additional VLAN pools require distinct default gateway settings set to the VLAN's respective router address.

## 5. Network Address Translation (NAT)

NAT remaps private IP address spaces (RFC 1918: 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16) to public IP addresses to mitigate IPv4 exhaustion and obscure internal network topology.

Functional NAT Types

* Static NAT: One-to-one permanent IP mapping. Typically used for port forwarding to allow external hosts to reach internal servers. Does not scale well.
* Dynamic NAT: Many-to-many dynamic mapping using a public IP pool. Useful when PAT is unsupported; limited by public pool size.
* Port Address Translation (PAT) / IP Masquerading: Many-to-one mapping. Translates multiple private IP addresses to a single public IP address by tracking conversations via dynamic Layer 4 TCP/UDP source port numbers. Flushes stateful translation tables after periods of inactivity to avoid port exhaustion.

Wildcard Masks

Cisco IOS uses wildcard masks for Access Control Lists and NAT rules. A wildcard mask is generated by inverting a standard subnet mask (changing 1s to 0s and 0s to 1s).

* Subnet Mask 255.255.255.0 \rightarrow Wildcard Mask 0.0.0.255
* Subnet Mask 255.255.255.252 \rightarrow Wildcard Mask 0.0.0.3
* Subnet Mask 255.255.240.0 \rightarrow Wildcard Mask 0.0.15.255
```
! Cisco NAT Interface Assignment
interface serial 0/0/0
 ip nat outside                      ! Defines public-facing WAN interface

interface vlan 100
 ip nat inside                       ! Defines private-facing LAN interface
```
