$ErrorActionPreference = "Stop"

mkdir Package -Force
mkdir Package\Assets -Force

copy ScreenMonitor.exe Package\

$logo = [System.Drawing.Bitmap]::new(150, 150)
$g = [System.Drawing.Graphics]::FromImage($logo)
$g.Clear([System.Drawing.Color]::FromArgb(26, 111, 181))
$f = [System.Drawing.Font]::new("Arial", 36, [System.Drawing.FontStyle]::Bold)
$b = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
$g.DrawString("SM", [System.Drawing.PointF]::new(10, 40), $f, $b)
$logo.Save("Package\Assets\StoreLogo.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $logo.Dispose(); $f.Dispose(); $b.Dispose()

copy AppxManifest.xml Package\

$m = Get-ChildItem "C:\Program Files (x86)\Windows Kits\10\bin\*\x64\MakeAppx.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $m) {
    $m = Get-ChildItem "C:\Program Files\Windows Kits\10\bin\*\x64\MakeAppx.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
}
Write-Output "MakeAppx: $($m.FullName)"
& $m.FullName pack /d Package /p ScreenMonitor.msix /o

Write-Output "MSIX created: $((Get-Item ScreenMonitor.msix).Length / 1MB) MB"
