- [ ] корректно устанавливать модули Powershell  
  при установке модулей Powershell возможна ситуация когда какой-то алиас или команда уже существует.  
  в таком случае установка не сообщает об ошибке, но модуль также не ставится.  
  от этого должна спасать опция -AllowClobber, но она пока не поддерживается DSC ресурсом.  
  например: при уже установленном pscx не сможет поставиться PSScriptTools (и наоборот)