# Lab 3-1: DHCP Capture

## Synopsis
Used Wireshark to capture a full DHCP exchange by releasing and renewing the IP address on a machine. The capture was then inspected to identify each DHCP operation, the DHCP server's address, and what configuration the server handed out along with the IP address.

## Order of Operations
1. Opened Wireshark and got a terminal ready with the release command typed but not entered.
2. Started the Wireshark capture.
3. Released the IP address, then requested a new one.
4. Stopped the capture and filtered it down to DHCP traffic.
5. Went through each packet to answer the lab questions.

**Peculiarity:** The capture had 8 DHCP packets instead of the usual 4 in DORA (Discover, Offer, Request, ACK). There was also an extra Release and an extra Request at the start. The network has **two** DHCP servers (`192.171.155.254` and `192.171.155.253`), and both answered the Discover. That's why there were two Offers and two ACKs.

## Results
| # | DHCP Operation |
| -- | -- |
| 1 | Release |
| 2 | Request |
| 3 | Discover |
| 4 | Offer |
| 5 | Offer |
| 6 | Request |
| 7 | ACK |
| 8 | ACK |

* **DHCP Server IPs:** 192.171.155.254 and 192.171.155.253
* **Source IP of the Offer packet:** The Offer comes from the DHCP server's own IP address, so the source is the server that sent it.
* **Other config the DHCP server provided:** Subnet Mask, Default Gateway, and DNS Suffix

## Things I learned
* DHCP follows the **DORA** process: **D**iscover (client broadcast), **O**ffer (server), **R**equest (client), **A**CK (server).
* Releasing the IP sends a DHCP Release to the server so the lease can be given back to the pool.
* If more than one DHCP server is on the network, every server can answer. The client picks one Offer to Request, but you can still see replies from both servers in the capture.

## Commands
```bash
# --- Kali (Linux) ---
sudo dhclient -r      # Releases the current DHCP lease (sends a DHCP Release)
sudo dhclient         # Requests a new lease (starts the Discover/Offer/Request/ACK process)

# --- Windows ---
ipconfig /release     # Releases the current DHCP lease
ipconfig /renew       # Requests a new lease from the DHCP server

# --- Wireshark display filter ---
dhcp                  # Shows only DHCP packets (use "bootp" on older Wireshark versions)
```

---

# Lab 3-2: Lab Prep

## Synopsis
Continued with the Week 2 Packet Tracer file and added a Generic Server directly to the East-Core-Switch on the Management VLAN (VLAN 1). The server got a static address from the Mgmt subnet, and the switch got its own VLAN 1 address to act as the gateway. The goal was a working ping from the server to the router and the other devices on the network. This server becomes the DHCP server in Lab 3-3.

## Order of Operations
1. Opened the completed Week 2 Packet Tracer file.
2. Placed a Generic Server to the left of the East-Core-Switch.
3. Gave the server a static IP of `10.9.15.2 /24` with gateway `10.9.15.1` (Mgmt subnet from the Lab 2-1 subnet table).
4. Configured East-Core-Switch `Fa0/3` as an access port on VLAN 1.
5. Gave the VLAN 1 interface on the East-Core-Switch the address `10.9.15.1` and brought it up with `no shutdown`.
6. Connected the server's `F0` to East-Core-Switch `Fa0/3`.
7. Pinged from the server to the router and other IPs on the network, then took a screenshot.

**Peculiarity:** The VLAN 1 interface is **shut down by default** on the switch, unlike the other VLAN interfaces made in Lab 2. Pings fail until you run `no shutdown` under `interface vlan 1`, even when the IP address is correct.

## Commands
```
! East-Core-Switch
enable                                      ! Enter privileged EXEC mode
configure terminal                          ! Enter global config mode

interface fastethernet 0/3                  ! Select the port the server plugs into
 switchport mode access                     ! Make it an access port (not a trunk)
 switchport access vlan 1                   ! Put the port on VLAN 1 (Mgmt)
 exit

interface vlan 1                            ! Enter the VLAN 1 (Mgmt) virtual interface
 ip address 10.9.15.1 255.255.255.0         ! Give the switch the Mgmt gateway address
 no shutdown                                ! VLAN 1 is shut down by default, so turn it on
 exit

end                                         ! Return to privileged EXEC mode
write memory                                ! Save the running config

! Server Desktop > Command Prompt
ping 10.9.15.1                              ! Test connectivity to the East-Core-Switch gateway
```

---

# Lab 3-3: DHCP Server in Packet Tracer

## Synopsis
Turned the Lab Prep server into a DHCP server (**DHCP-01**) so hosts get their IPs automatically instead of being set by hand like in Lab 2. Made a DHCP pool for each user VLAN, used `ip helper-address` on the East-Core-Switch so DHCP broadcasts could get past the router, and switched all clients from static to DHCP.

## Order of Operations
1. Reviewed the Lab 2-1 subnet table to get each VLAN's network, mask, and router address.
2. Renamed the server to **DHCP-01**, went to the Services tab, and turned DHCP on.
3. Changed the default **serverPool** start address to `.100` and used it for VLAN 1 (Mgmt).
4. Made a pool for FacStaff, Student, StuLab1, and StuLab2 (see table below).
5. Tested the server by plugging a workstation into East-Core-Switch `Fa0/4` on VLAN 1 and running `ipconfig /renew`.
6. Added `ip helper-address 10.9.15.2` on the VLAN 100, 110, 130, and 140 interfaces of the East-Core-Switch.
7. Switched every Admin, Student, and Lab workstation and laptop from Static to DHCP and checked that they all got addresses and could ping each other.

**Peculiarity:** DHCP requests are **broadcasts**, and routers don't forward broadcasts. The VLAN 1 test workstation got an address right away because it's on the same subnet as DHCP-01. Clients on the other VLANs got nothing until the `ip helper-address` was added. That command makes the switch turn the broadcast into a unicast and send it to the DHCP server.

## DHCP Pools (configured on DHCP-01 > Services > DHCP)
DNS Server and TFTP Server were left at `0.0.0.0` for every pool.

| Pool Name | VLAN | Default Gateway | Start IP | Subnet Mask | Max Users |
| -- | -- | -- | -- | -- | -- |
| serverPool | 1 (Mgmt) | 10.9.15.1 | 10.9.15.100 | 255.255.255.0 | 150 |
| FacStaff | 100 | 10.9.14.1 | 10.9.14.20 | 255.255.255.0 | 200 |
| Student | 110 | 10.9.12.1 | 10.9.12.50 | 255.255.254.0 | 450 |
| StuLab1 | 130 | 10.9.16.129 | 10.9.16.140 | 255.255.255.192 | 35 |
| StuLab2 | 140 | 10.9.16.1 | 10.9.16.20 | 255.255.255.128 | 65 |

## Tech Journal: DHCP in Packet Tracer
**Creating pools**
* Click the server > **Services** > **DHCP** > set Service to **On**.
* Type a new Pool Name, fill in Default Gateway, DNS Server, Start IP, Subnet Mask, Max Users, and TFTP, then click **Add**.
* The Default Gateway must be the router address **for that VLAN**, not the server's gateway.
* Make sure Start IP + Max Users stays inside the subnet. For example, a `/24` starting at `.100` only has room for about 154 hosts.

**Working with serverPool**
* serverPool is the default pool and **can't be removed**. It can only be edited.
* It serves the subnet the server sits on, which here is VLAN 1 (Mgmt). Change its Start IP and click **Save**, not **Add**.

**Assigning IP helper addresses**
* Set on the **VLAN interface** of the device doing the routing (East-Core-Switch), once for each user VLAN.
* The helper address is the **DHCP server's IP** (`10.9.15.2`), not a gateway.

**Issues encountered**
* Clients outside VLAN 1 didn't get an address until the helper address was set on their VLAN interface.
* A wrong subnet mask in a pool gives clients an address that can't reach its gateway. Check every mask against the subnet table.

## Commands
```
! East-Core-Switch: DHCP relay for each user VLAN
enable                                      ! Enter privileged EXEC mode
configure terminal                          ! Enter global config mode

interface vlan 100                          ! FacStaff VLAN interface
 ip helper-address 10.9.15.2                ! Forward DHCP broadcasts to DHCP-01
 exit
interface vlan 110                          ! Student VLAN interface
 ip helper-address 10.9.15.2                ! Forward DHCP broadcasts to DHCP-01
 exit
interface vlan 130                          ! StuLab1 VLAN interface
 ip helper-address 10.9.15.2                ! Forward DHCP broadcasts to DHCP-01
 exit
interface vlan 140                          ! StuLab2 VLAN interface
 ip helper-address 10.9.15.2                ! Forward DHCP broadcasts to DHCP-01
 exit

interface fastethernet 0/4                  ! Port for the VLAN 1 test workstation
 switchport mode access                     ! Make it an access port
 switchport access vlan 1                   ! Put it on the Mgmt VLAN
 exit

end                                         ! Return to privileged EXEC mode
write memory                                ! Save the running config
show running-config                         ! Check that the helper addresses are applied

! Client PC Desktop > Command Prompt
ipconfig /renew                             ! Ask the DHCP server for an address
ipconfig                                    ! Check the IP, mask, and gateway that were assigned
ping 10.9.15.2                              ! Test connectivity to DHCP-01 across VLANs
```
