# Lab 4-1: Small Enterprise Class Lab

## Synopsis
Built a three-hospital enterprise network (West, Central, East) in Packet Tracer. Each hospital has one 3650 multilayer switch (MLS) in the distribution layer and two edge switches (North Wing and South Wing). The MLS routes between that hospital's Clinic and Admin VLANs and connects to the edge switches with trunks. Each edge switch has access ports for both VLANs, and one PC per VLAN was attached and given a static IP. The deliverable was a successful ping from the West Clinic PC to the East Admin PC.

## VLAN Assignments
| VLAN Name | VLAN # | Net/Mask | Default Gateway |
| -- | -- | -- | -- |
| West Clinic | 100 | 192.168.10.0/24 | 192.168.10.1 |
| West Admin | 110 | 192.168.11.0/24 | 192.168.11.1 |
| Central Clinic | 200 | 192.168.20.0/24 | 192.168.20.1 |
| Central Admin | 210 | 192.168.21.0/24 | 192.168.21.1 |
| East Clinic | 300 | 192.168.30.0/24 | 192.168.30.1 |
| East Admin | 310 | 192.168.31.0/24 | 192.168.31.1 |
| Backbone (future) | 50 | 192.168.50.0/24 |  |

## Order of Operations
1. Placed a 3650 MLS and two edge switches for each portion of the hospital, then cabled the MLS to both edge switches.
2. Configured each MLS: hostname, `ip routing`, the hospital's VLANs. the West-MLS as the SVI (VLAN Interface) to act as the default gateway, and trunk ports on all MLSs to the switch's.
3. Configured each edge switch: hostname, the VLAN of the connected PC, one access port for the VLAN, and a trunk port up to the MLS. Then saved the config.
4. Attached a Clinic PC and an Admin PC to the edge switches and gave each a static IP, mask, and gateway from the VLAN table.
5. Pinged from the West Clinic PC to the East Admin PC (`192.168.31.2`). All 4 replies came back with 0% loss.

**Peculiarity:** The lab says to run `switchport trunk encapsulation dot1q` before setting trunk mode, but the 3650 MLS doesn't accept that command. The 3650 only supports 802.1Q, so no encapsulation type needs to be picked and `switchport mode trunk` works on its own. The encapsulation command is only needed on older switches like the 3560 that also support ISL. Also, the topology diagram labels the MLSs as Cat 3750, but the lab says to use the 3650.

## Notes
* **New commands:** None. `hostname`, VLANs, SVIs, and trunking were already covered in Lab 2. The only new command was `switchport trunk encapsulation dot1q`, and the 3650 doesn't use it.
* **Issues:** No real issues, but typing the same commands into 9 switches was tedious.
* **Scripting in Packet Tracer:** Packet Tracer has limited TCL scripting. It's easier to write the config in Notepad (or have a script generate it) and paste it into the switch CLI. The CLI runs pasted lines one at a time just like typed commands.
* `copy run start` saves the config. Changes take effect right away but are lost on reboot if they aren't saved.
* `do show run` shows the running config without leaving configuration mode.
* Putting `no` in front of a command removes that line from the config.

## Commands
The command blocks below show examples of the west MLS, which is acting as the router, so for the other MLSs the SVI does not need to be set. And the other example is of the North-West-Wing-Switch.  
Note: All of my VLAN names are abbreviated.
```
! ===== West-MLS (Cisco 3650) =====
enable                                      ! Enter privileged EXEC mode
configure terminal                          ! Enter global config mode
hostname West-MLS                           ! Name the switch
ip routing                                  ! Turn on layer 3 routing on the MLS

vlan 100                                    ! Create the West Clinic VLAN
 name WC                                    ! Name the VLAN
vlan 110                                    ! Create the West Admin VLAN
 name WA                                    ! Name the VLAN
 exit
vlan 200
 name CC
 exit
vlan 210
 name CA
 exit
vlan 300
 name EC
 exit
vlan 310
 name EA
 exit
vlan 50
 name Backbone
 exit


interface vlan 100                          ! SVI for West Clinic
 ip address 192.168.10.1 255.255.255.0      ! Default gateway for the Clinic VLAN
 no shutdown                                ! Bring the SVI up
interface vlan 110
 ip address 192.168.11.1 255.255.255.0
 exit
interface vlan 200
 ip address 192.168.20.1 255.255.255.0
 exit
interface vlan 210
 ip address 192.168.21.1 255.255.255.0
 exit
interface vlan 300
 ip address 192.168.30.1 255.255.255.0
 exit
interface vlan 310
 ip address 192.168.31.1 255.255.255.0
 exit
interface vlan 50
 ip address 192.168.50.1 255.255.255.0
 exit

interface range gigabitethernet 1/0/1 - 3   ! Ports going down to the North and South wing switches and to other mls
 switchport mode trunk                      ! Trunk (3650 is dot1q-only, so no encapsulation command needed)
 exit

end                                         ! Return to privileged EXEC mode
copy run start                              ! Save the running config to startup
```

```
! ===== North-West-Wing-SW (edge switch) =====
enable                                      ! Enter privileged EXEC mode
configure terminal                          ! Enter global config mode
hostname North-West-Wing-SW                 ! Name the switch

vlan 100                                    ! Create the same VLANs as the MLS
 name WC

interface fastethernet 0/1                  ! Access port for the Clinic VLAN
 switchport mode access                     ! Make it an access port
 switchport access vlan 100                 ! Put it on West Clinic
 exit

interface gigabitethernet 0/1               ! Uplink to West-MLS
 switchport mode trunk                      ! Trunk so both VLANs can reach the MLS
 exit

end                                         ! Return to privileged EXEC mode
copy run start                              ! Save the running config to startup
! Repeat for other switches and change values as needed
```

```
! ===== Useful checks =====
show vlan brief                             ! Shows the VLANs and which ports are on each
show interfaces trunk                       ! Shows which ports are trunking and which VLANs they carry
show ip interface brief                     ! Shows the SVI IPs and whether they're up
do show run                                 ! Shows the running config from inside config mode

! ===== West-Clinic PC > Desktop > Command Prompt =====
ping 192.168.31.2                           ! Test from West Clinic to the East Admin PC
```
