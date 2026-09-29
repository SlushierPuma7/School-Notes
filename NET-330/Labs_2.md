# Lab 2-1: Subnet Design
## Subnet Table:

| VLAN | VLAN-NAME | Hosts needed | network | netmask | Router address |
| -- | -- | -- | -- | -- | -- |
| 1 | management | 250 | 10.9.15.1 - 10.9.15.254 | /24 | 10.9.15.1 |
| 100 | FacStaff | 200 | 10.9.14.1 - 10.9.14.254 | /24 | 10.9.14.1 |
| 110 | student | 450 | 10.9.12.1 - 10.9.13.254 | /23 | 10.9.12.1 |
| 130 | StuLab1 | 35 | 10.9.16.129 - 10.9.16.192 | /26 | 10.9.16.129 |
| 140 | StuLab2 | 65 | 10.9.16.1 - 10.9.16.126 | /25 | 10.9.16.1 |
| 200 | StuWireless | 1024 | 10.9.0.1 - 10.9.7.254 | /21 | 10.9.0.1 |
| 210 | FSWireless | 650 | 10.9.8.1 - 10.9.11.254 | /22 | 10.9.8.1 |

## Notes From Lab
**Things I learned in the Lab:**
* I learned a variety of different commands to use in the command terminal in CISCO Packet Tracer that help with assigning port ranges to specific VLANS and how to configure a core switch as a router for VLANs so communication is possible across multiple networks.

## Useful CISCO Packet Tracer commands
* Command `enable` enters privileged mode.
* Command `config t` enters config mode.
* Command `interface fasterthernet x/x` enters config mode for a fasterthernet port.
* command `switchport mode [mode that you want to enter]` switches what mode the port is in. [ Access and Trunk] For Trunk, you need to specify an encapsulation type, like dot1q.
* command `exit` exits the current configuration mode you are in.
* command `reload` restarts a router.
* command `no` before another configuration command to remove the configuration.
* command `erase` to erase all configurations on a router.
* command `show run` shows the configuration table.
* command `ip address [desired ip] [subnet mask]` to assign an IP address.
* command `router rip` to enable router configuration
* command `vlan #` to make a new VLAN
* command `name xxx` to name the VLAN
* To setup a sub-interface, you add a ".#" to the end of "interface ethernet x/x/x.#." Next, you do encapsulation, then ip address, and repeat.
* Commands `interface range fastethernet 0/x-y` and `switchport access vlan x`. The first command defines the port range that you want to configure, while the second command defines what VLAN those ports will be set to.
```
Command `ip routing`
Command `interface vlan x`
Command `ip address x.x.x.x[IP] x.x.x.x[mask]`

These three commands are used for turning on routing on a multilayer switch and configuring VLAN routing through the multilayer switch
```
