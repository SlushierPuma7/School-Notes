# Labs 9

## Lab 9-1 Build-a-Network: Challenge 1
### What was done
- This lab was mostly setup, consisting of everything from previous labs. What was set up in this lab:
- Normal IP configurations on routers
- VLANs on a multilayer switch
- OSPF on 3 routers

- The Laptops were already configured in the lab document provided
- For submission, a screenshot of the command `sh ip route` on routers BTV-Router and MTL-Router was taken, as well as a screenshot of User-Laptop pinging Montreal Laptop

### Issues
- Came across a configuration error on the multi-layer switch with assigning the IP. You must establish `no switchport` for the port you are trying to assign an IP address to.

### Code Used
Montreal-MTL Router:
```
enable
configure terminal
hostname MTL-Router-Alex
interface serial 0/1/0
ip address 172.16.0.2 255.255.255.252
no shutdown
exit
interface fastethernet 0/0
ip address 172.16.20.1 255.255.255.0
no shutdown
exit

# OSPF configuration
router ospf 1
network 172.16.20.0 0.0.0.255 area 0
network 172.16.0.0 0.0.0.3 area 0
exit
```

BTV Router:
```
enable
configure terminal
hostname BTV-Router-Alex
interface serial 0/1/0
ip address 172.16.0.1 255.255.255.252
no shutdown
exit
interface fastethernet 0/0
ip address 172.16.10.1 255.255.255.0
no shutdown
exit

# OSPF configuration
router ospf 1
network 172.16.10.0 0.0.0.255 area 0
network 172.16.0.0 0.0.0.3 area 0
exit
```

BTV Multi-Layer Switch:
```
enable
configure terminal
hostname BTV-Dist-Alex
interface fastethernet 0/1
ip address 172.16.10.2 255.255.255.0
no shutdown
exit
vlan 5
name Users
vlan 6
name DC
interface vlan 5
ip address 172.16.5.1 255.255.255.0
no shutdown
exit
interface vlan 6
ip address 172.16.6.1 255.255.255.0
no shutdown
exit
interface range fastethernet 0/2 - 5
switchport mode access
switchport access vlan 5
exit
interface range fastethernet 0/6 - 9
switchport mode access
switchport access vlan 6
exit

# OSPF configuration
router ospf 1
network 172.16.10.0 0.0.0.255 area 0
network 172.16.5.0 0.0.0.255 area 0
network 172.16.6.0 0.0.0.255 area 0
exit
```

## Lab 9-2 Build-a-Network: Challenge 2 BGP
### What was done
- Similar to Challenge 1, the base configuration was set up for the routers and the laptops were already configured.
- What differs here is that there was no OSPF configurations made, besides for slight additions to BTV-Router. Instead of OSPF, BGP was used.
- BGP was configured on routers: BTV-Router, Vermont-ISP, Pacific-ISP, Partner Co, and Customer Co.
- Something interesting about BGP is that it can be used in tandem with OSPF. The OSPF configurations in Foster 202 were shared with Vermont-ISP. And when building the BGP tables, you don't need to add networks already established on other routers, as they communicate the tables between each other.

### Issues
- None. Yippee

### Code Used
BTV-Router:
```
enable
configure terminal
interface fastethernet 0/1
ip address 192.168.2.2 255.255.255.252
no shutdown
exit
ip route 0.0.0.0 0.0.0.0 192.168.2.1

# OSPF configuration
router ospf 1
default-information originate
exit

# BGP configurations
router bgp 3033
neighbor 192.168.2.1 remote-as 1010
redistribute ospf 1
exit
```

Vermont-ISP Router:
```
enable
configure terminal
hostname Vermont-ISP-Alex
interface fastethernet 0/0
ip address 192.168.1.1 255.255.255.252
no shutdown
exit
interface fastethernet 0/1
ip address 192.168.2.1 255.255.255.252
no shutdown
exit

# BGP configurations
router bgp 1010
neighbor 192.168.2.2 remote-as 3033
neighbor 192.168.1.2 remote-as 2054
network 192.168.1.0 mask 255.255.255.252
network 192.168.2.0 mask 255.255.255.252
exit
```

Pacific-ISP Router:
```
enable
configure terminal
hostname Pacific-ISP-Alex
interface fastethernet 0/0
ip address 192.168.1.2 255.255.255.252
no shutdown
exit
interface fastethernet 0/1
ip address 192.168.3.1 255.255.255.252
no shutdown
exit
interface serial 0/1/0
ip address 192.168.4.1 255.255.255.252
no shutdown
exit

# BGP configurations
router bgp 2054
neighbor 192.168.1.1 remote-as 1010
neighbor 192.168.3.2 remote-as 34908
neighbor 192.168.4.2 remote-as 5132
network 192.168.3.0 mask 255.255.255.252
network 192.168.4.0 mask 255.255.255.252
exit
```

Partner Co Router:
```
enable
configure terminal
hostname Partner-co-Alex
interface fastethernet 0/0
ip address 192.168.3.2 255.255.255.252
no shutdown
exit
interface fastethernet 0/1
ip address 10.15.6.1 255.255.255.0
no shutdown
exit

# BGP configurations
router bgp 34908
neighbor 192.168.3.1 remote-as 2054
network 10.15.6.0 mask 255.255.255.0
exit
```

Customer Co Router:
```
enable
configure terminal
hostname Customer-co-Alex
interface serial 0/1/0
ip address 192.168.4.2 255.255.255.252
no shutdown
exit
interface fastethernet 0/0
ip address 10.200.24.1 255.255.255.0
no shutdown
exit

# BGP configurations
router bgp 5132
neighbor 192.168.4.1 remote-as 2054
network 10.200.24.0 mask 255.255.255.0
exit
```
