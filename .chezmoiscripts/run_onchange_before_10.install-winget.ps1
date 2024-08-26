#!/usr/bin/env powershell

$cacheDir = $env:XDG_CACHE_HOME, "$env:USERPROFILE\.cache" | Select-Object -First 1
$cacheDir = Join-Path $cacheDir 'bootstrap'
$packages = @(
  ('https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx', 'Microsoft.VCLibs.x64.14.00.Desktop.appx'),
  ('https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx', 'Microsoft.UI.Xaml.2.8.x64.appx'),
  ('https://aka.ms/getwinget', 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'))

if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
  New-Item $cacheDir -ItemType Directory -Force | Out-Null

  $packages | ForEach-Object { 
    ($src, $dst) = ($_[0], (Join-Path $cacheDir $_[1]))
    if (!(Test-Path $dst -PathType Leaf)) {
      Start-BitsTransfer -Source $src -Destination $dst
    }
    Add-AppxPackage $dst
  }
}
