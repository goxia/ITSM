
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 需要提权执行...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
echo 易升清理
wmic product where "name like 'updateassistant'" call uninstall /nointeractive
wmic product where "name like '%%kb4023057%%'" call uninstall /nointeractive
wmic product where "name like '%%kb4023814%%'" call uninstall /nointeractive
taskkill /F /IM windows10upgraderapp.exe /T
rd /S /Q c:\windows10upgrade
taskkill /F /IM windows10upgrade.exe /T
rd /S /Q C:\windows\updateassistant
rd /S /Q C:\windows\updateassistantv2
del %CD%\"微软 Windows 10 易升.lnk" /Q
echo 禁用Windows Update
sc stop wuauserv
sc config wuauserv start= disabled
rd /S /Q C:\Windows\SoftwareDistribution
reg add HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v DeferUpgrade /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v DisableOSUpgrade /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v DoNotConnectToWindowsUpdateInternetLocations /t REG_DWORD /d 1 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate /v DoNotConnectToWindowsUpdateInternetLocations /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\WindowsUpdate /v DoNotConnectToWindowsUpdateInternetLocations /t REG_DWORD /d 1 /f
.\lgpo.exe /m .\denyconnectinternetupdate.pol /q
gpupdate /force
echo 执行完毕，请手工复查...
pause
