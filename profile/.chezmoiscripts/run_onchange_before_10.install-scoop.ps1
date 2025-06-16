#!/usr/bin/env powershell

$cacheDir = $env:XDG_CACHE_HOME, "$env:USERPROFILE\.cache" | Select-Object -First 1
$prerequisites = @{
  buckets = 'main', 'extras'
  apps    = (
    'main/git',
    'main/chezmoi',
    'extras/age')
}

if (!(Get-Command scoop -ErrorAction SilentlyContinue) -and !(Test-Path ~/.scoop/shims)) {
  Invoke-Expression "&{$(Invoke-RestMethod 'https://get.scoop.sh')} -ScoopDir $env:USERPROFILE\.scoop -ScoopCacheDir $cacheDir\scoop"
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
