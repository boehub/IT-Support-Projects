# Runbook: Customer Handoff

**Version:** 1.0

## When to use this

At the end of every job, before you leave or return the PC.

## What you need

- The Toolkit run logs (`Logs/<PCNAME>_<date>_<time>`), including `00_summary.txt` from Auto-Fix and `QuickCheck.txt`
- Your notes from the visit

## Steps

1. **Verify the original problem is fixed** with the customer watching, if possible.
2. **Restart the PC once more** and confirm it comes back cleanly. Auto-Fix may report that a restart is recommended.
3. **Return their files.**
   - Confirm they can find their files where they expect them.
   - If you restored files, check a few together.
   - If the PC was not restored, give them the backup copy in a form they can open.
4. **Explain in plain language.** What was wrong, what you did, and what, if anything, still needs attention. Skip jargon.
5. **Give a short written summary.** Use the layout below.
6. **Flag anything that needs a decision:** a drive near failure, a battery worn out, an out-of-date Windows version, no backup routine, a licence that is not activated.
7. **Close out the data.** Once the customer has confirmed their files, delete their backup from the USB and the log folders that contain their information. Tell them you have.
8. **Ask them to call if the problem returns,** and how.

## Summary layout

```
Customer:      
Date:          
PC:            make / model / serial
Reported:      what the customer said was wrong
Found:         what you actually found
Done:          what you changed or repaired
Backup:        made / verified / deleted on (date)
Still needs:   anything left for the customer to decide or do
Advice:        e.g. back up regularly, replace battery, upgrade RAM
```

## How to confirm it worked

The customer has seen it working, has their files, has a written summary, and their data is off your USB.

## If it did not work

If the problem is not fully resolved, say so plainly and agree on the next step. Do not hand the PC back as "fixed" when it is not.

## Notes

- Do not take payment details, passwords, or licence keys on paper or in the logs.
- Windows activation: Quick Check only reports the state. If the PC is not activated, use Settings > System > Activation > Troubleshoot or a valid key. Do not use unofficial activation tools.
