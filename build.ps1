$ErrorActionPreference = "Stop"

mkdir Package -Force
mkdir Package\Assets -Force

copy ScreenMonitor.exe Package\
copy StoreLogo.png Package\Assets\

copy AppxManifest.xml Package\

$m = Get-ChildItem "C:\Program Files (x86)\Windows Kits\10\bin\*\x64\MakeAppx.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $m) {
    $m = Get-ChildItem "C:\Program Files\Windows Kits\10\bin\*\x64\MakeAppx.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
}
Write-Output "MakeAppx: $($m.FullName)"
& $m.FullName pack /d Package /p ScreenMonitor.msix /o

Write-Output "MSIX created: $((Get-Item ScreenMonitor.msix).Length / 1MB) MB"
