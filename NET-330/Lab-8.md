# Week 10

## Lab 8-1B OSPF PT Activity

### Routing Table
| Network Name | Network Address | Subnet Mask | Default Gateway | Router Acting as Gateway |
| --- | --- | --- | --- | --- |
| Border to Data Center | 10.0.1.0 | 255.255.255.248 | 10.0.1.1 | Border |
| East-Router2 to Data Center | 10.0.1.20 | 255.255.255.252 | 10.0.1.21 | East-Router |
| Data Center to West-Router4 | 10.0.1.32 | 255.255.255.252 | 10.0.1.33 | Data Center Router |
| East | 10.1.20.0 | 255.255.255.0 | 10.1.20.1 | East-Router |
| West | 10.2.40.0 | 255.255.255.0 | 10.2.40.1 | West-Router |

### What was done
- Base configuration for routers and PCs was done first; no cabling was required as a Packet Tracer file with everything laid out was provided.
- OSPF was set up next. The commands to set up OSPF can be seen in the code for each router. Essentially, you specify an instance number to begin, then input all of the networks that are on that router. One thing that did confuse me is the wildcard_mask. This is essentially the inverse of the subnet_mask. So 255.255.255.0 (subnet) is 0.0.0.255 (wildcard). The command structure for adding the networks is: `network [network_address] [wildcard_mask] area #`.

### Issues
- Did not realize that each network on the router needed to be specified for OSPF, so went in and did that.
- Accidentally misconfigured the IP address for the East Router Default gateway for the East Network and had to fix it for pings to work.

### Code Executed

West Router:
```
enable
configure terminal
hostname Alex_WestRouter4
interface gigabitethernet 0/1
ip address 10.2.40.1 255.255.255.0
no shutdown
exit
interface gigabitethernet 0/0
ip address 10.0.1.34 255.255.255.252
no shutdown
exit

# OSPF configuration
router ospf 1
network 10.2.40.0 0.0.0.255 area 0
network 10.0.1.32 0.0.0.3 area 0
exit
```

East Router:
```
enable
configure terminal
hostname Alex_EastRouter2
interface gigabitethernet 0/1
ip address 10.1.20.1 255.255.255.0
no shutdown
exit
interface gigabitethernet 0/0
ip address 10.0.1.21 255.255.255.252
no shutdown
exit

# OSPF configuration
router ospf 1
network 10.1.20.0 0.0.0.255 area 0
network 10.0.1.20 0.0.0.3 area 0
exit
```

Data Center Router:
```
enable
configure terminal
hostname Alex_DataCenterRouter3
interface gigabitethernet 0/1
ip address 10.0.1.33 255.255.255.252
no shutdown
exit
interface gigabitethernet 0/0
ip address 10.0.1.22 255.255.255.252
no shutdown
exit
interface gigabitethernet 0/2
ip address 10.0.1.2 255.255.255.248
no shutdown
exit

# OSPF configuration
router ospf 1
network 10.0.1.0 0.0.0.7 area 0
network 10.0.1.20 0.0.0.3 area 0
network 10.0.1.32 0.0.0.3 area 0
exit
```

Border Router:
```
enable
configure terminal
hostname Alex_BorderRouter1
interface gigabitethernet 0/0
ip address 10.0.1.1 255.255.255.248
no shutdown
exit

# OSPF configuration
router ospf 1
network 10.0.1.0 0.0.0.7 area 0
exit
```
