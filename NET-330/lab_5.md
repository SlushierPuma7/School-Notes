# Lab 5-1: Small Enterprise-Class Lab
## Synopsis
This lab involves designing and building a small enterprise network in Cisco Packet Tracer for a community healthcare facility. The network uses multiple VLANs for clinic staff, visitors, office staff, counseling, and network services, with a multilayer switch providing routing between them. You will also configure DHCP and DNS servers, trunk links, VLAN port assignments, and verify connectivity through DHCP addressing, inter-VLAN pings, and DNS resolution.

## Subnet Table
| Name       | ID  | # of Hosts | Network Address | Subnet Mask | Host Ranges                  | Default Gateway | DHCP Pool Ranges             |
|------------|-----|------------|-----------------|-------------|------------------------------|-----------------|------------------------------|
| Clinic     | 400 | 300        | 10.20.0.0       | /23         | 10.20.0.1 - 10.20.1.254     | 10.20.0.1       | 10.20.0.200 - 10.20.1.254   |
| Office     | 300 | 300        | 10.20.2.0       | /23         | 10.20.2.1 - 10.20.3.254     | 10.20.2.1       | 10.20.2.200 - 10.20.3.254   |
| Visitor    | 200 | 300        | 10.20.4.0       | /23         | 10.20.4.1 - 10.20.5.254     | 10.20.4.1       | 10.20.4.200 - 10.20.5.254   |
| Counseling | 100 | 150        | 10.20.6.0       | /24         | 10.20.6.1 - 10.20.6.254     | 10.20.6.1       | 10.20.6.100 - 10.20.6.254   |
| Default    | 1   | 150        | 10.20.7.0       | /24         | 10.20.7.1 - 10.20.7.254     | 10.20.7.1       | 10.20.7.100 - 10.20.7.254   |

## Lab Instructions
1. Build Subnet Table.
2. Design the network and give each system a hostname. For the lab, an image was provided as an example, and one will be at the end of this lab. One thing to ensure: have PCs connected to edge switches for testing purposes.
   * Use 2960 switches for edge and core routers and a 3750 MLS for the border.
3. Configure Hospital router (MLS): Enable routing, add VLANs, add IP addresses to VLAN interfaces, and configure trunk ports to core switches.
4. Core switches: configure trunk ports to MLS and edge switches, and add VLANs.
5. Edge switches: configure trunk ports to core switches, add VLANs, and configure VLAN ports.
   * 6 ports for Clinic
   * 4 ports for Visitor
   * 6 ports for Office
6. Configure DHCP server: Provide proper address, turn on DHCP, create DHCP pools, connect to Data Center Core Switch, and assign helper addresses on MLS.
7. Configure clients on edge switches for DHCP.
8. Configure DNS: assign proper addresses, connect to the Data Center Core Switch, turn DNS on, and create A Records for the DNS and DHCP server. *example name: dhcp.ten.com*
   * May need to either speed up so DHCP renewals happen or release and renew.

## Issues
* The only issue that occurred was typos in IP Addresses.

## Commands
```
------------------VLAN copy-paste for switches----------------------
vlan 100
 name COUNSELING

vlan 200
 name VISITOR

vlan 300
 name OFFICE

vlan 400
 name CLINIC

# Copied into CLI on switches to assign VLANs

```
```
---------------Fastethernet VLAN assign copy-paste------------------
interface range fastethernet 0/5 - 8
 switchport mode access
 switchport access vlan 200

interface range fastethernet 0/9 - 14
 switchport mode access
 switchport access vlan 300

interface range fastethernet 0/15 - 20
 switchport mode access
 switchport access vlan 400

# Altered as needed
```
