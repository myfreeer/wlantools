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

:CheckPerm
if "%1" == ""  goto :Error
set "SSID=%1"
if "%2" == "" goto :Connect
if "%2" == "WPAPSK" goto :AES
if "%2" == "WPA2PSK" goto :AES
set "authentication=open"
set "encryption=none"
goto :AddProfile

:AES
if "%3" == "" goto :Error
set "authentication=%2"
set "encryption=AES"
set "Password=%3"

:AddProfile
(
    echo ^<^?xml version=^"1.0^"^?^>
    echo ^<WLANProfile xmlns=^"http:^/^/www.microsoft.com^/networking^/WLAN^/profile^/v1^"^>
    echo 	^<name^>%SSID%^<^/name^>
    echo 	^<SSIDConfig^>
    echo 		^<SSID^>
    echo 			^<name^>%SSID%^<^/name^>
    echo 		^<^/SSID^>
    echo 	^<^/SSIDConfig^>
    echo 	^<connectionType^>ESS^<^/connectionType^>
    echo 	^<MSM^>
    echo 		^<security^>
    echo 			^<authEncryption^>
    echo 				^<authentication^>%authentication%^<^/authentication^>
    echo 				^<encryption^>%encryption%^<^/encryption^>
    echo 			^<^/authEncryption^>
    echo 		^<^/security^>
    echo 	^<^/MSM^>
    echo ^<^/WLANProfile^>
) > "%TEMP%\TempProfile.xml"
netsh wlan add profile filename="%TEMP%\TempProfile.xml"
if "%encryption%" == "AES" ( netsh wlan set profileparameter ^
    name="%SSID%" ^
    SSIDname="%SSID%" ^
    authentication=%authentication% ^
    keyType=passphrase ^
    keyMaterial="%Password%" )
netsh wlan connect "%SSID%" && del /f /q "%TEMP%\TempProfile.xml"
goto :ConnectWlan_End

:Connect
netsh wlan connect "%SSID%"
goto :ConnectWlan_End

:Error
echo. Error!

:ConnectWlan_End
::timeout /t 5 || pause