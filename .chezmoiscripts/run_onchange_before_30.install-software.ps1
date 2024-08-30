#!/usr/bin/env powershell

$env:path += "$env:USERPROFILE\.scoop\shims;"

$softwareToInstall = @{
  scoop = (
    # -- terminal & shells
    'extras/windows-terminal',
    'main/pwsh',
    'main/nu',
    'main/oh-my-posh',
    # -- essentials
    'main/scoop-search',
    'main/micro',
    'main/bat',
    'main/delta'
  )
  winget = @()
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
