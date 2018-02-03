@echo off
setlocal EnableExtensions EnableDelayedExpansion
color 1f
:--------------------------------------------------------------------------
REG QUERY "HKU\S-1-5-19" >nul 2>&1
if %errorlevel% NEQ 0 goto :UACPrompt
goto :gotAdmin
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~fs0 %*", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /b
:gotAdmin
pushd "%~dp0"
:--------------------------------------------------------------------------
title dns change cmd

:set_ipv4_dns_all
rem usage: call :set_ipv4_dns_all DNS1 DNS2
if "%~1" == "" exit /b -1
if "%~2" == "" exit /b -2
wmic path Win32_NetworkAdapterConfiguration where IPEnabled="TRUE" call SetDynamicDNSRegistration TRUE
wmic path Win32_NetworkAdapterConfiguration where IPEnabled="TRUE" call SetDNSServerSearchOrder ("%~1", "%~2")
ipconfig /flushdns >nul
exit /b

:set_ipv6_dns_all
rem usage: call :set_ipv6_dns_all DNS1 DNS2
if "%~1" == "" exit /b -1
if "%~2" == "" exit /b -2
for /f "skip=1" %%i in ('"wmic path Win32_NetworkAdapterConfiguration where IPEnabled='TRUE' get Index"') do if "%%~i" neq "" call :set_ipv6_dns "%%~i" "%~1" "%~2"
ipconfig /flushdns >nul
exit /b

:set_ipv6_dns
rem usage: call :set_ipv6_dns Index DNS1 DNS2
if "%~1" == "" exit /b -1
set NetConnectionID=
for /f "skip=1" %%i in ('"wmic path Win32_NetworkAdapter where Index='%~1' get NetConnectionID"') do (
    set NetConnectionID=%%i
    goto :set_ipv6_dns_break
)
:set_ipv6_dns_break
if "%NetConnectionID%" == "" exit /b -2
if "%~2" == "" exit /b -3
netsh int ipv6 add dns "%NetConnectionID%" "%~2" index=1 validate=no
if "%~3" == "" exit /b 1
netsh int ipv6 add dns "%NetConnectionID%" "%~3" index=2 validate=no
exit /b
