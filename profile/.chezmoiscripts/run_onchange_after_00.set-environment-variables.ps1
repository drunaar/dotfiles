$path = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::User)
if (-not ($path -split ';' -contains 'C:\Users\CONALZ\.local\bin')) {
    [System.Environment]::SetEnvironmentVariable('PATH', 'C:\Users\CONALZ\.local\bin;' + $path, 'user')
}

[System.Environment]::SetEnvironmentVariable('XDG_CACHE_HOME', '%USERPROFILE%\.cache', 'user')
[System.Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME', '%USERPROFILE%\.config', 'user')
[System.Environment]::SetEnvironmentVariable('XDG_DATA_HOME', '%USERPROFILE%\.local\share', 'user')
[System.Environment]::SetEnvironmentVariable('XDG_STATE_HOME', '%USERPROFILE%\.local\state', 'user')
