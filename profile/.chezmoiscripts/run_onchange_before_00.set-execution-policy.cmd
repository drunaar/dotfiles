<# ::
@powershell -nop -ex remotesigned -<%~f0 && goto:eof
#>

Set-ExecutionPolicy RemoteSigned CurrentUser -Force
