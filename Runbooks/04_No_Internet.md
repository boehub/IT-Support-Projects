# Runbook: No Internet

**Version:** 1.0

## When to use this

The PC cannot get online, pages will not load, or the connection keeps dropping.

## What you need

- The Toolkit USB (Network Fix)
- A second device (phone) to tell whether the problem is this PC or the network
- An Ethernet cable, if you want to rule out Wi-Fi

## Steps

1. **Is it just this PC?** Check if a phone on the same Wi-Fi has internet.
   - Phone also has no internet: the problem is the router, modem, or ISP. Go to step 6.
   - Phone works: the problem is this PC. Continue.
2. **Run Network Fix > Diagnose** (read-only). It reports whether the router, internet by IP, DNS, and DHCP work, and prints a verdict.
3. **Read the verdict and act on it.**

| Verdict | Do this |
|---|---|
| Cannot reach the router | Check Wi-Fi is on (airplane mode, Fn key, adapter enabled). Reconnect to the network. Try a cable |
| No IP address from DHCP (169.254.x.x) | Restart the router. Try a cable. Forget and rejoin the Wi-Fi network |
| Router reachable but no internet | The problem is upstream: restart modem and router, wait 2 minutes, check for an ISP outage |
| Internet works by IP, names fail | DNS problem. Run **Standard fix**, or set DNS to 1.1.1.1 and 8.8.8.8 |
| Everything healthy | Check the browser, proxy, VPN, and the specific website |

4. **Run Standard fix** (flush DNS, renew IP). Test again.
5. **Run Restart adapters.** Test again.
   - If the Wi-Fi card is missing or shows an error, check Device Manager and update or reinstall the driver. Use a cable or phone tethering to download it.
   - Run **Wi-Fi tools > Wi-Fi report** for dropouts and disconnect reasons.
6. **Router side.** Power off the modem and router for 30 seconds, then modem first, router second. Check the router's lights against its manual.
7. **Full reset** (Network Fix option 4) only after the steps above fail.
   - It resets Winsock, TCP/IP, IPv6, and the proxy. Static IP and DNS settings may be cleared, so note them first.
   - Saved Wi-Fi networks are kept. A restart is required.
8. **Check for a proxy or VPN** left on from earlier: Settings > Network & Internet > Proxy, and any VPN apps.

## How to confirm it worked

A page loads after a restart, and Network Fix Diagnose reports a healthy network. Check at a different time if the problem was intermittent.

## If it did not work

- Problem with every device: contact the ISP.
- Only one device, still failing after a full reset and a driver reinstall: the Wi-Fi card or port may have failed. Test with a USB Wi-Fi or Ethernet adapter.

## Notes

- Do not change router settings or passwords without the owner's permission.
- Do not run a full reset on a work or school PC with managed network settings.
- Command details: [Network_Commands.md](../Reference/Network_Commands.md).
