# Runbooks and SOPs

Step-by-step procedures for common support jobs. Each one has the same layout so it can be followed during a visit without thinking about structure: **when to use it, what you need, steps, how to confirm it worked, and when to escalate**.

| Runbook | Use it when |
|---|---|
| [01_Repair_Visit_Checklist.md](01_Repair_Visit_Checklist.md) | Starting any repair visit, from arrival to handoff |
| [02_PC_Wont_Boot.md](02_PC_Wont_Boot.md) | The PC does not power on, does not reach Windows, or loops on startup |
| [03_Slow_PC.md](03_Slow_PC.md) | The customer says the PC is slow, freezes, or takes forever to start |
| [04_No_Internet.md](04_No_Internet.md) | The PC cannot get online or pages will not load |
| [05_Suspected_Malware.md](05_Suspected_Malware.md) | Pop-ups, hijacked browser, unknown programs, or a security warning |
| [06_Customer_Handoff.md](06_Customer_Handoff.md) | Finishing a job: summary, verification, and what to tell the customer |
| [_TEMPLATE.md](_TEMPLATE.md) | Writing a new runbook |

## Principles that apply to every runbook

1. **Permission first.** Only work on a PC the owner has agreed you can work on.
2. **Back up before changing anything.** Use the [Toolkit](../TechClub-Toolkit/) Backup tool, and check it reported OK.
3. **Read-only before repairs.** Diagnose, then fix.
4. **Change one thing at a time** and test after each change, so you know what worked.
5. **Write down what you did.** The Toolkit logs help, but note anything done by hand.
6. **Never keep customer data.** Wipe backups from the USB when the job is closed and the customer has confirmed their files.
7. **Know when to stop.** A failing drive, a customer's confidential data, or anything beyond your skill goes to someone more qualified.

Commands used here are explained in the [Reference sheets](../Reference/), and the parts are explained in the [Hardware Guide](../Hardware-Guide/).
