#!/usr/bin/env powershell

$cacheDir = $env:XDG_CACHE_HOME, "$env:USERPROFILE\.cache" | Select-Object -First 1
$cacheDir = Join-Path $cacheDir 'bootstrap'
$packages = @(
  ('https://github.com/microsoft/winget-cli/releases/download/v1.10.390/DesktopAppInstaller_Dependencies.zip', 'DesktopAppInstaller_Dependencies.zip'),
  ('https://github.com/microsoft/winget-cli/releases/download/v1.10.390/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle', 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'))


if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
  New-Item $cacheDir -ItemType Directory -Force | Out-Null

  $packages | ForEach-Object {
    ($src, $dst) = ($_[0], (Join-Path $cacheDir $_[1]))
    if (!(Test-Path $dst -PathType Leaf)) {
      Start-BitsTransfer -Source $src -Destination $dst
    }
  }

  Join-Path $cacheDir ($packages | Where-Object { $_[1] -like '*.zip' } | Select-Object -First 1)[1] `
  | Expand-Archive -DestinationPath $cacheDir -Force

  $msixBundle = Join-Path $cacheDir ($packages | Where-Object { $_[1] -like '*.msixbundle' } | Select-Object -First 1)[1]
  $dependencies = Join-Path $cacheDir 'x64' | Get-ChildItem -File -Filter '*.appx'

  Add-AppxPackage  $msixBundle -DependencyPath $dependencies

  'arm', 'arm64', 'x86', 'x64' | % { Remove-Item (Join-Path $cacheDir $_) -Recurse -ErrorAction SilentlyContinue }

  winget list --accept-source-agreements | Out-Null
}
