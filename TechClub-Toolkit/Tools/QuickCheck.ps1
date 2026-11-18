# ============================================================
#  TECH CLUB QUICK CHECK
#  Windows activation + Wi-Fi card + sound test.
#  Read-only: it changes nothing on the PC. Start it with QuickCheck.bat
#  Use -SkipSound to leave out the interactive speaker test.
# ============================================================
param([switch]$SkipSound)

$ErrorActionPreference = 'SilentlyContinue'
$Root    = Split-Path -Path $PSScriptRoot -Parent
$Stamp   = Get-Date -Format 'yyyyMMdd_HHmmss'
$LogDir  = Join-Path $Root ("Logs\{0}_{1}" -f $env:COMPUTERNAME, $Stamp)
$null    = New-Item -ItemType Directory -Path $LogDir -Force
$LogFile = Join-Path $LogDir 'QuickCheck.txt'
$Results = New-Object System.Collections.ArrayList
$Colors  = @{ PASS = 'Green'; WARN = 'Yellow'; FAIL = 'Red'; INFO = 'Cyan'; SKIP = 'DarkGray' }

function Say {
    param([string]$Text, [string]$Color = 'Gray')
    Write-Host $Text -ForegroundColor $Color
    Add-Content -LiteralPath $LogFile -Value $Text
}

function Add-Result {
    param([string]$Check, [string]$Status, [string]$Detail = '')
    [void]$Results.Add([pscustomobject]@{ Check = $Check; Status = $Status; Detail = $Detail })
    $line = '  [{0}] {1}' -f $Status, $Check
    if ($Detail) { $line += ' - ' + $Detail }
    Say $line $Colors[$Status]
}

function Section {
    param([string]$Title)
    Say ''
    Say ('=== ' + $Title + ' ===') 'Cyan'
}

# Builds a short stereo sine tone as an in-memory WAV. $Channel: L, R or LR
function New-ToneStream {
    param([double]$Freq = 440, [int]$Millis = 900, [string]$Channel = 'LR')
    $rate    = 44100
    $count   = [int]($rate * $Millis / 1000)
    $dataLen = $count * 4
    $mem = New-Object System.IO.MemoryStream
    $bw  = New-Object System.IO.BinaryWriter($mem)
    $ascii = [System.Text.Encoding]::ASCII
    $bw.Write($ascii.GetBytes('RIFF')); $bw.Write([int](36 + $dataLen)); $bw.Write($ascii.GetBytes('WAVE'))
    $bw.Write($ascii.GetBytes('fmt ')); $bw.Write([int]16); $bw.Write([int16]1); $bw.Write([int16]2)
    $bw.Write([int]$rate); $bw.Write([int]($rate * 4)); $bw.Write([int16]4); $bw.Write([int16]16)
    $bw.Write($ascii.GetBytes('data')); $bw.Write([int]$dataLen)
    $fade = [int]($rate * 0.03)
    for ($i = 0; $i -lt $count; $i++) {
        $amp = 1.0
        if ($i -lt $fade) { $amp = $i / $fade }
        elseif ($i -gt ($count - $fade)) { $amp = ($count - $i) / $fade }
        $v = [int16](14000 * $amp * [math]::Sin(2 * [math]::PI * $Freq * $i / $rate))
        $left  = [int16]0
        $right = [int16]0
        if ($Channel -match 'L') { $left = $v }
        if ($Channel -match 'R') { $right = $v }
        $bw.Write($left); $bw.Write($right)
    }
    $bw.Flush()
    $mem.Position = 0
    return $mem
}

function Test-Tone {
    param([string]$Label, [double]$Freq, [string]$Channel)
    [void](Read-Host ("  Press Enter to play the {0} tone" -f $Label))
    $stream = New-ToneStream -Freq $Freq -Channel $Channel
    $player = New-Object System.Media.SoundPlayer($stream)
    $player.PlaySync()
    $player.Dispose()
    $answer = Read-Host ("  Did you hear the {0} tone? (Y/n)" -f $Label)
    return ($answer -notmatch '^[nN]')
}

# ------------------------------------------------------------ header
$cs   = Get-CimInstance Win32_ComputerSystem
$bios = Get-CimInstance Win32_BIOS
$os   = Get-CimInstance Win32_OperatingSystem

Say '==========================================================' 'Cyan'
Say '  TECH CLUB QUICK CHECK  -  Activation / Wi-Fi / Sound' 'Cyan'
Say '==========================================================' 'Cyan'
Say ("  Machine : {0}   ({1} {2})" -f $env:COMPUTERNAME, $cs.Manufacturer, $cs.Model)
Say ("  Serial  : {0}" -f $bios.SerialNumber)
Say ("  Windows : {0}   build {1}" -f $os.Caption, $os.BuildNumber)
Say ("  Checked : {0}" -f (Get-Date))
if ([int]$os.BuildNumber -ge 22000) { Add-Result 'Windows version' 'INFO' 'Windows 11' }
else { Add-Result 'Windows version' 'WARN' ('Not Windows 11 (build {0})' -f $os.BuildNumber) }

# ------------------------------------------------------------ 1. activation
Section '1 of 3   WINDOWS ACTIVATION'
$statusMap = @{
    0 = 'Unlicensed'
    1 = 'Licensed - activated'
    2 = 'Initial grace period - not yet activated'
    3 = 'Additional grace period - activation expiring'
    4 = 'Non-genuine grace period'
    5 = 'Notification mode - NOT activated'
    6 = 'Extended grace period'
}
$lic = Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "ApplicationId='55c92734-d682-4d71-983e-d6ec3f16059f' AND PartialProductKey IS NOT NULL" | Select-Object -First 1

if (-not $lic) {
    Add-Result 'Windows activation' 'FAIL' 'No product key is installed - Windows is not activated'
} else {
    $st    = [int]$lic.LicenseStatus
    $label = $statusMap[$st]
    Say ("  Edition  : {0}" -f $lic.Name)
    Say ("  Channel  : {0}" -f $lic.Description)
    Say ("  Key ends : {0}" -f $lic.PartialProductKey)
    $fwKey = (Get-CimInstance -ClassName SoftwareLicensingService).OA3xOriginalProductKey
    Say ("  Key embedded in BIOS/UEFI: {0}" -f $(if ($fwKey) { 'Yes' } else { 'No' }))
    $xpr = (& cscript.exe //nologo "$env:windir\System32\slmgr.vbs" /xpr 2>&1 | ForEach-Object { "$_".Trim() } | Where-Object { $_ } | Select-Object -Last 1)
    if ($xpr) { Say ("  Expiry   : {0}" -f $xpr) }

    if ($st -eq 1) {
        Add-Result 'Windows activation' 'PASS' $label
    } elseif ($st -in 2, 3, 6) {
        $days = [math]::Round($lic.GracePeriodRemaining / 1440, 1)
        Add-Result 'Windows activation' 'WARN' ("{0} - about {1} days left" -f $label, $days)
    } else {
        Add-Result 'Windows activation' 'FAIL' $label
    }
    if ($lic.Description -match 'KMS|TIMEBASED|GVLK') {
        Add-Result 'License type' 'INFO' 'Volume/KMS license - it must keep reaching its KMS server to stay activated'
    }
    if ($st -ne 1) {
        Say '  Fix: Settings > System > Activation > Troubleshoot. Sign in with the Microsoft account' 'Yellow'
        Say '       that was used before (digital licenses follow the account), or enter a valid key.' 'Yellow'
        Say '       A new motherboard usually unlinks a digital license until you run Troubleshoot.' 'Yellow'
    }
}

# ------------------------------------------------------------ 2. wi-fi
Section '2 of 3   WI-FI CARD'
$wifiPnp = @(Get-CimInstance Win32_PnPEntity | Where-Object {
    $_.PNPClass -eq 'Net' -and
    $_.Name -match 'Wi-?Fi|Wireless|802\.11|WLAN' -and
    $_.Name -notmatch 'Virtual|Miniport|Wi-Fi Direct|Bluetooth'
})
$wifiNet = @(Get-NetAdapter -Physical | Where-Object {
    $_.PhysicalMediaType -match '802\.11' -or $_.InterfaceDescription -match 'Wi-?Fi|Wireless|802\.11|WLAN'
})

if ($wifiPnp.Count -eq 0 -and $wifiNet.Count -eq 0) {
    Add-Result 'Wi-Fi card detected' 'FAIL' 'No Wi-Fi adapter found'
    Say '  Possible causes: desktop with no Wi-Fi card, card not seated or antenna module unplugged,' 'Yellow'
    Say '  Wi-Fi disabled in BIOS/UEFI, or driver missing (check Device Manager > Other devices).' 'Yellow'
} else {
    foreach ($d in $wifiPnp) {
        if ($d.ConfigManagerErrorCode -eq 0) {
            Add-Result 'Wi-Fi card detected' 'PASS' $d.Name
        } else {
            Add-Result 'Wi-Fi card detected' 'FAIL' ("{0} - Device Manager error code {1} (driver problem or faulty card)" -f $d.Name, $d.ConfigManagerErrorCode)
        }
        $escaped = $d.DeviceID -replace '\\', '\\'
        $drv = Get-CimInstance Win32_PnPSignedDriver -Filter ("DeviceID='{0}'" -f $escaped) | Select-Object -First 1
        if ($drv) {
            $drvDate = ''
            if ($drv.DriverDate) { $drvDate = Get-Date $drv.DriverDate -Format 'yyyy-MM-dd' }
            Say ("      Driver: {0}  version {1}  dated {2}" -f $drv.DriverProviderName, $drv.DriverVersion, $drvDate)
        }
    }
    if ($wifiPnp.Count -eq 0) {
        foreach ($a in $wifiNet) { Add-Result 'Wi-Fi card detected' 'PASS' $a.InterfaceDescription }
    }

    foreach ($a in $wifiNet) {
        switch ($a.Status) {
            'Up'           { Add-Result 'Wi-Fi adapter state' 'PASS' ("{0}: enabled and connected ({1})" -f $a.Name, $a.LinkSpeed) }
            'Disconnected' { Add-Result 'Wi-Fi adapter state' 'INFO' ("{0}: enabled, not connected to a network" -f $a.Name) }
            'Disabled'     { Add-Result 'Wi-Fi adapter state' 'WARN' ("{0}: DISABLED - right-click it in Network Connections and choose Enable" -f $a.Name) }
            default        { Add-Result 'Wi-Fi adapter state' 'WARN' ("{0}: status {1}" -f $a.Name, $a.Status) }
        }
    }

    $svc = Get-Service -Name WlanSvc
    if (-not $svc -or $svc.Status -ne 'Running') {
        Add-Result 'WLAN AutoConfig service' 'WARN' 'Not running - Wi-Fi cannot work until it is started'
    } else {
        Add-Result 'WLAN AutoConfig service' 'PASS' 'Running'
        $iface = (netsh wlan show interfaces 2>&1) -join "`n"
        if ($iface -match 'Software Off|Hardware Off') {
            Add-Result 'Wi-Fi radio' 'WARN' 'Radio is OFF - airplane mode, Wi-Fi switch, or Fn key'
        } else {
            if ($iface -match '(?m)^\s+Signal\s+:\s+(.+?)\s*$') { Say ("      Signal strength: {0}" -f $Matches[1]) }
            $nets  = (netsh wlan show networks mode=bssid 2>&1) -join "`n"
            $count = ([regex]::Matches($nets, '(?m)^SSID \d+ :')).Count
            if ($count -gt 0) {
                Add-Result 'Wi-Fi radio scan' 'PASS' ("Radio works - it can see {0} nearby network(s)" -f $count)
            } else {
                Add-Result 'Wi-Fi radio scan' 'WARN' 'Sees 0 networks - check antenna leads on desktop cards, airplane mode, or move closer to a router'
            }
        }
        if ($iface -match '(?m)^\s+State\s+:\s+connected') {
            if (Test-Connection -ComputerName 1.1.1.1 -Count 2 -Quiet) { Add-Result 'Internet over Wi-Fi' 'PASS' 'Reachable' }
            else { Add-Result 'Internet over Wi-Fi' 'WARN' 'Connected to Wi-Fi but the internet is not reachable' }
        }
    }
}

# ------------------------------------------------------------ 3. sound
Section '3 of 3   SOUND'
$audio    = Get-Service -Name Audiosrv
$builder  = Get-Service -Name AudioEndpointBuilder
if ($audio.Status -eq 'Running' -and $builder.Status -eq 'Running') {
    Add-Result 'Windows Audio services' 'PASS' 'Running'
} else {
    Add-Result 'Windows Audio services' 'FAIL' 'Windows Audio / Audio Endpoint Builder is not running'
}

$sound = @(Get-CimInstance Win32_SoundDevice)
if ($sound.Count -eq 0) {
    Add-Result 'Sound hardware' 'FAIL' 'No sound device found - no audio chip, disabled in BIOS, or driver missing'
} else {
    foreach ($s in $sound) {
        if ($s.ConfigManagerErrorCode -eq 0) { Add-Result 'Sound hardware' 'PASS' $s.Name }
        else { Add-Result 'Sound hardware' 'FAIL' ("{0} - Device Manager error code {1}" -f $s.Name, $s.ConfigManagerErrorCode) }
    }
}

$endpoints = @(Get-PnpDevice -Class AudioEndpoint -PresentOnly)
$playback  = @($endpoints | Where-Object { $_.InstanceId -match '\{0\.0\.0\.' })
$recording = @($endpoints | Where-Object { $_.InstanceId -match '\{0\.0\.1\.' })
foreach ($p in $playback) { Say ("      Playback : {0}" -f $p.FriendlyName) }
foreach ($r in $recording) { Say ("      Recording: {0}" -f $r.FriendlyName) }
if ($playback.Count -eq 0) {
    Add-Result 'Playback device' 'WARN' 'No active speakers/headphones - nothing plugged in, or the device is disabled'
} else {
    Add-Result 'Playback device' 'PASS' ("{0} found" -f $playback.Count)
}
if ($recording.Count -eq 0) { Add-Result 'Microphone' 'INFO' 'No active recording device' }
else { Add-Result 'Microphone' 'INFO' ("{0} recording device(s) found" -f $recording.Count) }

if ($SkipSound) {
    Add-Result 'Speaker test' 'SKIP' 'Skipped (-SkipSound)'
} elseif ($playback.Count -eq 0) {
    Add-Result 'Speaker test' 'SKIP' 'No playback device to test'
} else {
    Say ''
    Say '  Plug in speakers or headphones and turn the volume up (check it is not muted).' 'Yellow'
    $go = Read-Host '  Run the left/right speaker test now? (Y/n)'
    if ($go -match '^[nN]') {
        Add-Result 'Speaker test' 'SKIP' 'Skipped by tech'
    } else {
        $leftOk = Test-Tone -Label 'LEFT' -Freq 440 -Channel 'L'
        if ($leftOk) { Add-Result 'Left speaker' 'PASS' 'Tone heard' } else { Add-Result 'Left speaker' 'FAIL' 'Tone NOT heard' }
        $rightOk = Test-Tone -Label 'RIGHT' -Freq 880 -Channel 'R'
        if ($rightOk) { Add-Result 'Right speaker' 'PASS' 'Tone heard' } else { Add-Result 'Right speaker' 'FAIL' 'Tone NOT heard' }
        if (-not $leftOk -and -not $rightOk) {
            Say '  Heard nothing: check volume/mute, the selected output device in Settings > System > Sound,' 'Yellow'
            Say '  the cable/jack, and try another set of speakers or headphones.' 'Yellow'
        }
    }
}

# ------------------------------------------------------------ summary
Section 'SUMMARY'
foreach ($r in $Results) {
    if ($r.Status -ne 'INFO') {
        $line = '  [{0}] {1}' -f $r.Status, $r.Check
        if ($r.Detail) { $line += ' - ' + $r.Detail }
        Say $line $Colors[$r.Status]
    }
}
$fails = @($Results | Where-Object { $_.Status -eq 'FAIL' }).Count
$warns = @($Results | Where-Object { $_.Status -eq 'WARN' }).Count
Say ''
if ($fails -gt 0)     { Say ("  RESULT: {0} problem(s) and {1} warning(s) need attention." -f $fails, $warns) 'Red' }
elseif ($warns -gt 0) { Say ("  RESULT: no failures, {0} warning(s) to look at." -f $warns) 'Yellow' }
else                  { Say '  RESULT: everything checked is OK.' 'Green' }
Say ("  Report saved to: {0}" -f $LogFile)
