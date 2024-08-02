#!/usr/bin/env powershell

$prerequisites = @{
  buckets = 'main', 'extras'
  apps    = (
    'main/git',
    'main/chezmoi',
    'extras/age')
}

if (!(Get-Command scoop -ErrorAction SilentlyContinue) -and !(Test-Path ~/.scoop/shims)) {
  Invoke-Expression "&{$(Invoke-RestMethod 'https://get.scoop.sh')} -ScoopDir $env:USERPROFILE\.scoop"
  scoop install main/git
  scoop update
}

$currentState = scoop export | ConvertFrom-Json

$prerequisites.buckets `
| Where-Object { $_ -inotin $($currentState.buckets | ForEach-Object Name) } `
| ForEach-Object { scoop bucket add $_ }

$prerequisites.apps `
| Where-Object { $_ -inotin $($currentState.apps | ForEach-Object { "$($_.Source)/$($_.Name)" } ) } `
| ForEach-Object { scoop install $_ }
