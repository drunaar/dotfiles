#!/usr/bin/env powershell

$env:path += "$env:USERPROFILE\.scoop\shims;"
$cacheDir = $env:XDG_CACHE_HOME, "$env:USERPROFILE\.cache" | Select-Object -First 1
$cacheDir = Join-Path $cacheDir 'bootstrap'

$softwareToInstall = @{
  scoop = (
    # -- terminal & shells
    'main/nu',
    'main/oh-my-posh',
    # -- essentials
    'main/scoop-search',
    'main/micro',
    'main/bat',
    'main/delta',
    'extras/winmerge',
    'main/python',
    'main/nodejs',
    'main/uv'
  )
  appx = (
    # -- terminal & shells
    ('https://github.com/microsoft/terminal/releases/download/v1.22.11141.0/Microsoft.WindowsTerminal_1.22.11141.0_8wekyb3d8bbwe.msixbundle', 'Microsoft.WindowsTerminal_1.22.11141.0_8wekyb3d8bbwe.msixbundle', 'wt'),
    ('https://github.com/PowerShell/PowerShell/releases/download/v7.5.0/PowerShell-7.5.0-win.msixbundle', 'PowerShell-7.5.0-win.msixbundle', 'pwsh')
  )
  winget = @()
}

New-Item $cacheDir -ItemType Directory -Force | Out-Null

$softwareToInstall.appx | ForEach-Object {
  ($src, $dst, $cmd) = ($_[0], (Join-Path $cacheDir $_[1]), $_[2])
  if (!(Test-Path $dst -PathType Leaf)) {
    Start-BitsTransfer -Source $src -Destination $dst
  }

  if (!(Get-Command $cmd -ErrorAction SilentlyContinue)) {
    Add-AppxPackage $dst
  }
}

$softwareToInstall.winget `
| Where-Object { winget list --exact --id $_ --accept-source-agreements } `
| ForEach-Object { winget install --exact --id $_ --interactive --accept-source-agreements --accept-package-agreements }

$currentState = scoop export | ConvertFrom-Json

$softwareToInstall.scoop `
| ForEach-Object { ($_ -split '/')[0].ToLower() } | Select-Object -Unique `
| Where-Object { $_ -inotin $($currentState.buckets | ForEach-Object Name) } `
| ForEach-Object { scoop bucket add $_ }

$softwareToInstall.scoop `
| Where-Object { $_ -inotin $($currentState.apps | ForEach-Object { "$($_.Source)/$($_.Name)" } ) } `
| ForEach-Object { scoop install $_ }
