# Network Commands

## Diagnose from the inside out

Test in this order. The first step that fails tells you where the problem is.

| Step | Test | If it fails |
|---|---|---|
| 1. This PC's adapter | `ipconfig` shows an IP address | Cable, Wi-Fi switch or airplane mode, disabled adapter, driver |
| 2. Got an address from the router | Address is **not** `169.254.x.x` | DHCP problem: router, cable, weak Wi-Fi |
| 3. Router reachable | `ping <default gateway>` | Local link problem: cable, Wi-Fi signal, wrong network |
| 4. Internet reachable | `ping 1.1.1.1` | Router has no internet: modem, ISP |
| 5. Names resolve | `nslookup example.com` | DNS problem: try 1.1.1.1 or 8.8.8.8 |
| 6. Website loads | Open a page | Proxy, browser, firewall, or the site itself |

`169.254.x.x` is an APIPA address. Windows gives itself one when it asks for an address and gets no answer.

## Commands

| Command | Effect | What it does |
|---|---|---|
| `ipconfig /all` | Read-only | Full adapter details: IP, mask, gateway, DNS, DHCP server, MAC address |
| `ipconfig /flushdns` | Changes | Clears the DNS cache |
| `ipconfig /release` then `/renew` | Changes | Drops and re-requests the DHCP address. You lose connection briefly |
| `ipconfig /displaydns` | Read-only | Shows the DNS cache |
| `ping <host>` | Read-only | Tests reachability. `ping -t` repeats until Ctrl+C |
| `tracert <host>` | Read-only | Shows each hop to the destination |
| `pathping <host>` | Read-only | Combines ping and tracert with loss per hop. Takes a couple of minutes |
| `nslookup <host>` | Read-only | DNS lookup. `nslookup <host> 1.1.1.1` asks a specific server |
| `netstat -ano` | Read-only | Open connections and listening ports with process IDs |
| `arp -a` | Read-only | IP to MAC address table for the local network |
| `route print` | Read-only | Routing table |
| `netsh wlan show interfaces` | Read-only | Current Wi-Fi connection and signal |
| `netsh wlan show profiles` | Read-only | Saved Wi-Fi networks |
| `netsh wlan show wlanreport` | Read-only | Builds an HTML Wi-Fi history report |
| `netsh winhttp show proxy` | Read-only | Shows the system proxy |
| `netsh winsock reset` | Changes | Resets the Winsock catalog. Restart needed |
| `netsh int ip reset` | Changes | Resets TCP/IP to defaults. Restart needed. May clear static IP settings |
| `netsh winhttp reset proxy` | Changes | Removes the system proxy |

## Private IP ranges

| Range | CIDR | Typical use |
|---|---|---|
| 10.0.0.0 to 10.255.255.255 | 10.0.0.0/8 | Large and business networks |
| 172.16.0.0 to 172.31.255.255 | 172.16.0.0/12 | Medium networks |
| 192.168.0.0 to 192.168.255.255 | 192.168.0.0/16 | Home and small office routers |

## Subnet sizes

| CIDR | Subnet mask | Usable hosts |
|---|---|---|
| /8 | 255.0.0.0 | 16,777,214 |
| /16 | 255.255.0.0 | 65,534 |
| /24 | 255.255.255.0 | 254 |
| /25 | 255.255.255.128 | 126 |
| /26 | 255.255.255.192 | 62 |
| /27 | 255.255.255.224 | 30 |
| /28 | 255.255.255.240 | 14 |
| /30 | 255.255.255.252 | 2 |

Usable hosts = 2^(32 − prefix) − 2. The two removed are the network address and the broadcast address.

## Common ports

| Port | Protocol | Service |
|---|---|---|
| 20, 21 | TCP | FTP (data, control) |
| 22 | TCP | SSH and SFTP |
| 23 | TCP | Telnet (unencrypted, avoid) |
| 25 | TCP | SMTP (server to server mail) |
| 53 | TCP/UDP | DNS |
| 67, 68 | UDP | DHCP (server, client) |
| 80 | TCP | HTTP |
| 110 | TCP | POP3 |
| 123 | UDP | NTP (time) |
| 143 | TCP | IMAP |
| 443 | TCP | HTTPS |
| 445 | TCP | SMB file sharing |
| 587 | TCP | SMTP submission (mail clients sending) |
| 993 | TCP | IMAP over TLS |
| 995 | TCP | POP3 over TLS |
| 3389 | TCP | Remote Desktop (RDP) |

## Public DNS servers for testing

| Provider | IPv4 |
|---|---|
| Cloudflare | 1.1.1.1 and 1.0.0.1 |
| Google | 8.8.8.8 and 8.8.4.4 |
| Quad9 | 9.9.9.9 |

If names fail on the PC's own DNS but work with `nslookup example.com 1.1.1.1`, the problem is the DNS server the PC was given, usually the router.
