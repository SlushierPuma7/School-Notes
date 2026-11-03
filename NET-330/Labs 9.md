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
