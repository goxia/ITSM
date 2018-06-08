@echo off
set ChromeXP="\\Server\Chrome\49.0.2623.75_chrome_installer.exe"
set ChromeX86="\\Server\Chrome\v65.0.3325.181\googlechromestandaloneenterprise.msi"
set ChromeX64="\\Server\Chrome\v65.0.3325.181\googlechromestandaloneenterprise64.msi"
rem wmic product where name="google chrome" get name /value | findstr /i "Google Chrome"
rem if %errorlevel% equ 0 (goto :exit) else (goto :XPCondition)
for /f "tokens=2 delims==" %%p in ('wmic product where "description='Google chrome'" get description /value') do (set ProductName=%%p)

if exist %ProductName%=="Google Chrome" (goto :exit) else (goto :XPCondition)

:exit
echo Exist Google Chrome
exit /B

:XPCondition
ver | find /i "5.1.2600" > NUL && set OSVER=XP || Set OSVER=Win7Lase
if %OSVER%==XP (goto :XPInstaller) else (goto :ProcessorCondition)

:ProcessorCondition
if "%PROCESSOR_ARCHITECTURE%%PROCESSOR_ARCHITEW6432%"=="x86" goto x86
if "%PROCESSOR_ARCHITECTURE%%PROCESSOR_ARCHITEW6432%"=="AMD64" goto x64

:XPInstaller
reg add HKLM\SOFTWARE\Policies\Google\Chrome /v HomepageLocation /t REG_SZ /d http://eip.yutong.com /f
reg add HKLM\SOFTWARE\Policies\Google\Chrome /v ImportBookmarks /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Google\Chrome\Recommended /v ImportBookmarks /t REG_DWORD /d 1 /f
call %ChromeXP%

:x86
reg add HKLM\SOFTWARE\Policies\Google\Chrome /v HomepageLocation /t REG_SZ /d http://eip.yutong.com /f
reg add HKLM\SOFTWARE\Policies\Google\Chrome /v ImportBookmarks /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Google\Chrome\Recommended /v ImportBookmarks /t REG_DWORD /d 1 /f
call msiexec /i %ChromeX86% /qn /norestart
exit /B

:x64
reg add HKLM\SOFTWARE\Policies\Google\Chrome /v HomepageLocation /t REG_SZ /d http://eip.yutong.com /f
reg add HKLM\SOFTWARE\Policies\Google\Chrome /v ImportBookmarks /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Google\Chrome\Recommended /v ImportBookmarks /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\WOW6432Node\Policies\Google\Chrome /v HomepageLocation /t REG_SZ /d http://eip.yutong.com /f
reg add HKLM\SOFTWARE\WOW6432Node\Policies\Google\Chrome /v ImportBookmarks /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\WOW6432Node\Policies\Google\Chrome\Recommended /v ImportBookmarks /t REG_DWORD /d 1 /f
call msiexec /i %ChromeX64% /qn /norestart
exit /B


