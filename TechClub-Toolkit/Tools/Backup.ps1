# ============================================================
#  TECH CLUB BACKUP
#  Copies a customer's personal files to this USB drive BEFORE repairs.
#  COPY ONLY: nothing on the PC is moved, changed or deleted.
#  Browser passwords are deliberately NOT copied.
#  Start it with Backup.bat
# ============================================================
$ErrorActionPreference = 'Continue'
$Root       = Split-Path -Path $PSScriptRoot -Parent
$Stamp      = Get-Date -Format 'yyyyMMdd_HHmmss'
$Pc         = $env:COMPUTERNAME
$LogDir     = Join-Path $Root ("Logs\{0}_{1}" -f $Pc, $Stamp)
$BackupBase = Join-Path $Root ("Backups\{0}_{1}" -f $Pc, $Stamp)
$null       = New-Item -ItemType Directory -Path $LogDir -Force
$LogFile    = Join-Path $LogDir 'Backup.txt'
$DryTarget  = Join-Path $env:TEMP 'techclub_dry_run_target'

function Say {
    param([string]$Text, [string]$Color = 'Gray')
    Write-Host $Text -ForegroundColor $Color
    Add-Content -LiteralPath $LogFile -Value $Text
}

function Fmt {
    param([int64]$Bytes)
    if ($Bytes -ge 1GB) { return ('{0:N2} GB' -f ($Bytes / 1GB)) }
    if ($Bytes -ge 1MB) { return ('{0:N1} MB' -f ($Bytes / 1MB)) }
    return ('{0:N0} KB' -f ($Bytes / 1KB))
}

# Options shared by every folder copy
$RcCommon = @('/E', '/XJ', '/XA:O', '/R:1', '/W:1', '/BYTES', '/NJH', '/NP', '/NFL', '/NDL',
              '/XF', 'desktop.ini', 'Thumbs.db', '~$*')

function Get-RcSummary {
    param($Lines)
    $o = @{ Files = 0; Copied = 0; Failed = 0; Bytes = [int64]0; BytesCopied = [int64]0 }
    foreach ($l in $Lines) {
        $t = "$l"
        if ($t -match '^\s*Files\s*:\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)') {
            $o.Files = [int]$Matches[1]; $o.Copied = [int]$Matches[2]; $o.Failed = [int]$Matches[5]
        } elseif ($t -match '^\s*Bytes\s*:\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)') {
            $o.Bytes = [int64]$Matches[1]; $o.BytesCopied = [int64]$Matches[2]
        }
    }
    return $o
}

function New-BackupItem {
    param($Label, $Type, $Src, $Dest, $Spec = '')
    return [pscustomobject]@{ Label = $Label; Type = $Type; Src = $Src; Dest = $Dest; Spec = $Spec
                              Bytes = [int64]0; Files = 0; Status = '' }
}

function Get-BackupItems {
    param($Prof)
    $list = New-Object System.Collections.ArrayList
    $p    = $Prof.FullName
    $std  = 'Desktop', 'Documents', 'Pictures', 'Videos', 'Music', 'Downloads'

    foreach ($n in $std) {
        $s = Join-Path $p $n
        if (Test-Path -LiteralPath $s -PathType Container) { [void]$list.Add((New-BackupItem $n 'dir' $s $n)) }
    }
    # Folders redirected into OneDrive
    foreach ($od in @(Get-ChildItem -LiteralPath $p -Directory -Force -Filter 'OneDrive*')) {
        foreach ($n in $std) {
            $s = Join-Path $od.FullName $n
            if (Test-Path -LiteralPath $s -PathType Container) {
                $name = '{0}\{1}' -f $od.Name, $n
                [void]$list.Add((New-BackupItem $name 'dir' $s $name))
            }
        }
    }
    # Sticky Notes
    $sn = Join-Path $p 'AppData\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe\LocalState'
    if (Test-Path -LiteralPath $sn -PathType Container) {
        [void]$list.Add((New-BackupItem 'Sticky Notes' 'dir' $sn 'AppData\StickyNotes'))
    }
    # Chrome and Edge bookmarks
    $browsers = @( @('Chrome', 'AppData\Local\Google\Chrome\User Data'),
                   @('Edge',   'AppData\Local\Microsoft\Edge\User Data') )
    foreach ($b in $browsers) {
        $ud = Join-Path $p $b[1]
        if (Test-Path -LiteralPath $ud -PathType Container) {
            foreach ($bp in @(Get-ChildItem -LiteralPath $ud -Directory -Force | Where-Object { $_.Name -eq 'Default' -or $_.Name -like 'Profile *' })) {
                if (Test-Path -LiteralPath (Join-Path $bp.FullName 'Bookmarks')) {
                    $lbl = '{0} bookmarks ({1})' -f $b[0], $bp.Name
                    [void]$list.Add((New-BackupItem $lbl 'file' $bp.FullName ('Browsers\{0}\{1}' -f $b[0], $bp.Name) 'Bookmarks'))
                }
            }
        }
    }
    # Firefox bookmarks and history database
    $ff = Join-Path $p 'AppData\Roaming\Mozilla\Firefox\Profiles'
    if (Test-Path -LiteralPath $ff -PathType Container) {
        foreach ($fp in @(Get-ChildItem -LiteralPath $ff -Directory -Force)) {
            if (Test-Path -LiteralPath (Join-Path $fp.FullName 'places.sqlite')) {
                $lbl = 'Firefox bookmarks ({0})' -f $fp.Name
                [void]$list.Add((New-BackupItem $lbl 'file' $fp.FullName ('Browsers\Firefox\{0}' -f $fp.Name) 'places.sqlite*'))
            }
        }
    }
    return $list.ToArray()
}

function Measure-BackupItem {
    param($It)
    if ($It.Type -eq 'dir') {
        $out = & robocopy $It.Src $DryTarget /L @RcCommon /XD $BackupBase 2>&1
        $sm  = Get-RcSummary $out
        $It.Bytes = $sm.BytesCopied
        $It.Files = $sm.Copied
    } else {
        $f = @(Get-ChildItem -LiteralPath $It.Src -Filter $It.Spec -File -Force)
        $It.Files = $f.Count
        $It.Bytes = [int64]($f | Measure-Object -Property Length -Sum).Sum
    }
}

# ------------------------------------------------------------ header + destination checks
Clear-Host
Say '==========================================================' 'Yellow'
Say '  TECH CLUB BACKUP  -  copy customer files to this USB' 'Yellow'
Say '==========================================================' 'Yellow'
Say ("  Computer : {0}" -f $Pc)
Say ("  Running as: {0}" -f $env:USERNAME)
Say ("  Backups go to: {0}" -f (Join-Path $Root 'Backups'))
Say '  Copy only. Nothing on this PC is changed or deleted. Browser passwords are NOT copied.'
Say ''

$destRoot = [System.IO.Path]::GetPathRoot($Root)
$di = $null
try { $di = New-Object System.IO.DriveInfo($destRoot) } catch { }
if ($di) {
    if ($destRoot -eq ($env:SystemDrive + '\')) {
        Say '  WARNING: this toolkit is running from the PC''s own system drive.' 'Red'
        Say '  A backup on the same disk is not a backup. Plug in the USB drive and run it from there.' 'Red'
        $c = Read-Host '  Continue anyway? (y/N)'
        if ($c -notmatch '^[yY]') { Say '  Cancelled.' 'Yellow'; return }
    }
    if ($di.DriveFormat -eq 'FAT32') {
        Say '  WARNING: this USB is FAT32, which cannot hold any single file bigger than 4 GB.' 'Yellow'
        Say '  Those files will fail to copy. Reformat the USB as exFAT or NTFS to avoid this.' 'Yellow'
    }
    Say ("  USB free space: {0}  (format {1})" -f (Fmt $di.AvailableFreeSpace), $di.DriveFormat)
}

# ------------------------------------------------------------ pick profile(s)
$skipNames = 'Public', 'Default', 'Default User', 'All Users', 'Default.migrated'
$profiles  = @(Get-ChildItem -LiteralPath (Join-Path $env:SystemDrive 'Users') -Directory -Force |
               Where-Object { $skipNames -notcontains $_.Name })
if ($profiles.Count -eq 0) { Say '  No user profiles found.' 'Red'; return }

Say ''
Say '  User profiles on this PC:'
for ($i = 0; $i -lt $profiles.Count; $i++) { Say ("    [{0}] {1}" -f ($i + 1), $profiles[$i].Name) }
Say '    [A] All of them'
Say ''
$chosen = @()
while ($chosen.Count -eq 0) {
    $sel = Read-Host '  Which profile do you want to back up? (number, A, or Q to quit)'
    if ($sel -match '^[qQ]') { Say '  Cancelled.' 'Yellow'; return }
    if ($sel -match '^[aA]') { $chosen = $profiles }
    elseif ($sel -match '^\d+$' -and [int]$sel -ge 1 -and [int]$sel -le $profiles.Count) { $chosen = @($profiles[[int]$sel - 1]) }
}
$null = New-Item -ItemType Directory -Path $BackupBase -Force

# ------------------------------------------------------------ one profile at a time
$allSummaries = New-Object System.Collections.ArrayList

foreach ($prof in $chosen) {
    Say ''
    Say ("##### Profile: {0} #####" -f $prof.Name) 'Cyan'
    $items = @(Get-BackupItems $prof)
    if ($items.Count -eq 0) { Say '  Nothing to back up for this profile.' 'Yellow'; continue }
    if (@($items | Where-Object { $_.Label -like 'OneDrive*' }).Count -gt 0) {
        Say '  Note: OneDrive folders found. Online-only (cloud) files are skipped - they still exist in the cloud.' 'Yellow'
    }
    Say '  Measuring folder sizes (can take a few minutes on big profiles)...'
    foreach ($it in $items) { Measure-BackupItem $it }

    $skip = @{}
    $proceed = $false
    while ($true) {
        $total = [int64]0; $totalFiles = 0
        Say ''
        for ($k = 0; $k -lt $items.Count; $k++) {
            $it   = $items[$k]
            $mark = '      '
            if ($skip.ContainsKey($k)) { $mark = '[SKIP]' }
            else { $total += $it.Bytes; $totalFiles += $it.Files }
            Say ("   [{0,2}] {1} {2,-44} {3,11}  {4,8} files" -f ($k + 1), $mark, $it.Label, (Fmt $it.Bytes), $it.Files)
        }
        $free = if ($di) { $di.AvailableFreeSpace } else { [int64]::MaxValue }
        Say ("   Total to copy: {0} in {1} files.   Free on USB: {2}" -f (Fmt $total), $totalFiles, (Fmt $free))
        if ($total -gt ($free - 50MB)) {
            Say '   NOT ENOUGH SPACE on the USB for everything selected.' 'Red'
            $ans = Read-Host '   Type numbers to skip (e.g. 2,4) or press Enter to cancel'
            if (-not $ans) { Say '   Cancelled for this profile.' 'Yellow'; break }
        } else {
            $ans = Read-Host '   Press Enter to START, or type numbers to skip/unskip (e.g. 2,4)'
            if (-not $ans) { $proceed = $true; break }
        }
        foreach ($tok in ($ans -split '[,\s]+')) {
            if ($tok -match '^\d+$') {
                $n = [int]$tok - 1
                if ($n -ge 0 -and $n -lt $items.Count) {
                    if ($skip.ContainsKey($n)) { $skip.Remove($n) } else { $skip[$n] = $true }
                }
            }
        }
    }
    if (-not $proceed) { continue }

    # ---- copy
    $dest = Join-Path $BackupBase $prof.Name
    $null = New-Item -ItemType Directory -Path $dest -Force
    $active = @(for ($k = 0; $k -lt $items.Count; $k++) { if (-not $skip.ContainsKey($k)) { $items[$k] } })
    $n = 0
    Say ''
    foreach ($it in $active) {
        $n++
        $dst = Join-Path $dest $it.Dest
        Write-Host ("  [{0}/{1}] Copying {2} ..." -f $n, $active.Count, $it.Label) -ForegroundColor White
        if ($it.Type -eq 'dir') {
            $rcArgs = @($it.Src, $dst) + $RcCommon + @('/XD', $BackupBase, '/MT:4')
        } else {
            $rcArgs = @($it.Src, $dst, $it.Spec, '/R:1', '/W:1', '/BYTES', '/NJH', '/NP', '/NFL', '/NDL')
        }
        $out  = & robocopy @rcArgs 2>&1 | ForEach-Object { "$_" }
        $code = $LASTEXITCODE
        $sm   = Get-RcSummary $out
        Add-Content -LiteralPath $LogFile -Value ("--- {0}  (robocopy exit code {1}) ---" -f $it.Label, $code)
        Add-Content -LiteralPath $LogFile -Value $out
        if ($code -ge 8 -or $sm.Failed -gt 0) {
            $it.Status = 'PROBLEM'
            Say ("      PROBLEM: {0} file(s) failed (robocopy code {1}) - see log" -f $sm.Failed, $code) 'Red'
        } else {
            $it.Status = 'OK'
            Say ("      OK: {0} files, {1}" -f $sm.Copied, (Fmt $sm.BytesCopied)) 'Green'
        }
        $it.Files = $sm.Copied
        $it.Bytes = $sm.BytesCopied
    }

    # ---- per-profile summary file
    $lines = @()
    $lines += 'TECH CLUB BACKUP SUMMARY'
    $lines += ('Computer : {0}' -f $Pc)
    $lines += ('Profile  : {0}' -f $prof.Name)
    $lines += ('Backed up : {0}' -f (Get-Date))
    $lines += 'Method   : robocopy copy only (source untouched). Browser passwords not included.'
    $lines += ''
    foreach ($it in $active) { $lines += ('{0,-8} {1,-44} {2,11}  {3} files' -f $it.Status, $it.Label, (Fmt $it.Bytes), $it.Files) }
    $lines += ''
    $lines += 'To restore: copy the folders back into the matching user folders.'
    Set-Content -LiteralPath (Join-Path $dest '_BACKUP_SUMMARY.txt') -Value $lines
    [void]$allSummaries.Add([pscustomobject]@{ Profile = $prof.Name; Problems = @($active | Where-Object { $_.Status -eq 'PROBLEM' }).Count; Count = $active.Count })
}

# ------------------------------------------------------------ wrap up
Say ''
Say '==========================================================' 'Yellow'
if ($allSummaries.Count -eq 0) {
    Say '  Nothing was backed up.' 'Yellow'
} else {
    foreach ($s in $allSummaries) {
        if ($s.Problems -gt 0) { Say ("  {0}: {1} of {2} items had problems - check the log before repairing this PC" -f $s.Profile, $s.Problems, $s.Count) 'Red' }
        else { Say ("  {0}: all {1} items copied OK" -f $s.Profile, $s.Count) 'Green' }
    }
    Say ("  Backup folder: {0}" -f $BackupBase)
    Say ("  Log          : {0}" -f $LogFile)
    if (Test-Path -LiteralPath $BackupBase) { Start-Process explorer.exe -ArgumentList ('"{0}"' -f $BackupBase) }
}
