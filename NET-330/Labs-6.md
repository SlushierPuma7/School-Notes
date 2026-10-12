# Week 6 Labs

## Lab 6-1 NAT Configuration - Static NAT

### What was Done
- Lab file for Packet Tracer was downloaded and opened.
- Router 1 and 0 were configured statically
- Static NAT and rules were set up on Router 1

### Issues
- Don't know why I was using the actual web server IP, but I did. Router 1 is masking the real IP as 50.0.0.1, and the 50 address is what needs to be used to access the site.

### Code Executed
Router 1:
```
# Base Configuration
enable
configure terminal
hostname R1
interface fastethernet 0/0
ip address 10.0.0.1 255.0.0.0
no shutdown
exit
interface serial 0/0/0
ip address 20.0.0.2 255.0.0.0
no shutdown
exit

## Static Routing
ip route 30.0.0.0 255.0.0.0 20.0.0.1

## Static NAT
interface fastEthernet 0/0
ip nat inside
exit
interface serial 0/0/0
ip nat outside
exit

## Static Rule
ip nat inside source static 10.0.0.2 50.0.0.1
```

Router 0:
```
# Base Configuration
enable
configure terminal
hostname R0
interface fastethernet 0/0
ip address 30.0.0.1 255.0.0.0
no shutdown
exit
interface serial 0/0/0
ip address 20.0.0.1 255.0.0.0
clock rate 64000
bandwidth 64
no shutdown
exit

## Static Routing
ip route 50.0.0.0 255.0.0.0 20.0.0.2
```

## Lab 6-2 NAT configuration - PAT

### What was done
- Base configuration done to Routers 1 and 2
- Default gateway / gateway of last resort set on Router 1 pointing at Router 2
- PAT configured on Router 1

### Issues
- None

### Code Used

Router 1:
```
# Base Configuration
enable
configure terminal
hostname R1
interface fastEthernet 0/0
ip address 192.168.0.1 255.255.255.0
no shutdown
exit
interface serial 0/0/0
ip address 30.0.0.1 255.0.0.0
no shutdown
exit
ip route 0.0.0.0 0.0.0.0 30.0.0.2

# PAT Config
enable
configure terminal
interface fastEthernet 0/0
ip nat inside
exit
interface serial 0/0/0
ip nat outside
exit
ip nat pool test 30.0.0.120 30.0.0.120 netmask 255.0.0.0     # Sets NAT pool name, IP range, and netmask
access-list 1 permit 192.168.0.0 0.0.0.255                   # Sets who has access with the 0.0.0.255 showing available users
ip nat inside source list 1 pool test overload               # Overload allows multiple users to use the same IP, up to 64,0000
```

Router 2:
```
# Base Configuration
enable
configure terminal
hostname R2
interface serial 0/0/0
ip address 30.0.0.2 255.0.0.0
clock rate 64000
no shutdown
exit
interface fastEthernet 0/0
ip address 20.0.0.1 255.0.0.0
no shutdown
exit
```

## Lab 6-3 NAT LAB 3- Champlain example lab

### What was done
- IP addresses, netmask, and default gateway configured on PCs and servers
- PAT configured on Border Router so that Foster and Skiff PCs could reach Burlington Telecom
- Static NAT rule configured on Border Router so that Burlington Telecom could reach the Ireland web server.

### Issues
- Needed to correct an IP on the web server so BT could reach it; I accidentally used the wrong IP for the static rule.

### Code Used

CC Border Router:
```
# PAT configuration
enable
configure terminal
interface fastethernet 0/0
ip nat inside
exit
interface fastethernet 0/1
ip nat outside
exit
ip nat pool CCPAT 219.93.144.100 219.93.144.100 netmask 255.255.255.0
access-list 1 permit 192.168.1.0 0.0.0.255
access-list 1 permit 192.168.3.0 0.0.0.255
ip nat inside source list 1 pool CCPAT overload

## Static NAT configuration
ip nat inside source static 192.168.7.20 219.93.144.80
```
