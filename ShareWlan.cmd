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
call :n77
set msg=��ȷ�������ӵ����磬���򱾳��򲿷ֹ��ܿ����޷�����ʹ�á�

:ya
@title Windows WiFi ��������
@cls
@echo. %msg%
@echo.
@echo 1. ȷ���Լ��ʼǱ������Ƿ�֧�ֿ�������AP
@echo.
@echo 2. ���ò����� WiFi �ȵ㹲��
@echo.
@echo 3. ���� WiFi �ȵ㹲��
@echo.
@echo 4. ���� WiFi �ȵ㹲�������
@echo.
@echo 5. �鿴 ��������״̬
@echo.
@echo 6. �ر� WiFi �ȵ㹲��
@echo.
@echo 7. ���� WiFi �ȵ㹲��
@echo.
@echo 8. �˳�
@echo.
set msg=
if defined auto set auto=<nul
	CHOICE /C 123456789 /N /M "��ѡ�� [ 1 / 2 / 3 / 4 / 5 / 6 ] �س���"

	if %errorlevel%==1 goto :a1
	if %errorlevel%==2 goto :a2
	if %errorlevel%==3 goto :a3
	if %errorlevel%==4 goto :a4
	if %errorlevel%==5 goto :a5
	if %errorlevel%==6 goto :a6
	if %errorlevel%==7 goto :a7
	if %errorlevel%==8 goto :na
	if %errorlevel%==9 call :kk
	 
	goto :ya

:a1
@title ȷ���Լ��ʼǱ������Ƿ�֧�ֿ�������AP
@cls
call :BeginDateAndTime
@echo.
@echo �ȴ���������ɰ���������ع���ѡ�񣡡������˳���
@echo.
@echo �鿴 Hosted network supported ����֧�ֵĳ������� �����ʾ��
@echo ����� "Yes" �� "��" �ͱ�ʾ�������֧�� ��������WiFi�����繲��
@echo.
@netsh wlan show drivers|findstr ֧�ֵĳ�������
if %errorlevel%==0 ( set msg=�������֧�ֿ�������WiFi�����繲�� ) else ( set msg=���������֧�ֿ�������WiFi�����繲�� )
@echo.
@echo %msg%
@echo.
@echo ������ɰ���������ع���ѡ��
call :EndDateAndTime
::@pause >nul
timeout /t 5
@goto ya

:a2
@title ���ò����� WiFi �ȵ㹲��
@cls
@echo.
@echo �ȴ���������ɰ���������ع���ѡ�񣡡������˳���
@echo.
:a21
set auto=0
@set /p ssidv="����������WiFi����ʾ����(quit����):"
if [%ssidv%]==[] goto a21
if [%ssidv%]==[quit] goto ya
:a22
@set /p keyv="����������WiFi������(8λ����)(quit����):"
if [%keyv%]==[] goto a22
if /I [%keyv%]==[quit] goto ya
call :count %keyv%
::echo �������ַ���str����%num%���ַ�
if %num% lss 8 (echo �����������С��8λ�����������롣 &&goto a22)
CHOICE /M "�Ƿ񿪻��Զ����� WiFi �ȵ㹲��"
if %errorlevel%==1 set auto=1
echo.
call :BeginDateAndTime
sc start SharedAccess >nul
if %errorlevel% equ 1058 (sc config SharedAccess start= demand &sc start SharedAccess) >nul
sc config BFE start= demand>nul 2>nul
net start BFE>nul 2>nul
sc config mpsdrv start= demand>nul 2>nul
net start mpsdrv>nul 2>nul
sc config MpsSvc start= auto>nul 2>nul
net start MpsSvc>nul 2>nul
@echo.
@echo �����������WiFi����ʾ���ƣ�%ssidv%
@echo �����������WiFi�����룺%keyv%
@echo.
@netsh wlan set hostednetwork mode=allow ssid=%ssidv% key=%keyv%
@echo ����WiFi ������...
@echo.
@netsh wlan start hostednetwork
if %errorlevel%==0 ( set msg=��������WiFi�ɹ� ) else ( set msg=��������WiFiʧ�� )
call :ics on
if %auto%==1 SCHTASKS /Create /TN "WiFi �ȵ㹲��" /TR "netsh wlan start hostednetwork" /SC ONLOGON /RU SYSTEM /RL Highest /F >nul 2>&1
if defined auto set auto=<nul
@echo %msg%
@echo.
@echo ������ɰ���������ع���ѡ��
call :EndDateAndTime
::@pause >nul
timeout /t 5
@goto ya

:a3
@title ���� WiFi �ȵ㹲��
@cls
call :BeginDateAndTime
@echo.
@echo ����WiFi ����Ϊ����ģʽ��...
@echo.
@netsh wlan set hostednetwork mode=allow
@echo ����WiFi ������...
@echo.
@netsh wlan start hostednetwork
if %errorlevel%==0 ( set msg=��������WiFi�ɹ� ) else ( set msg=��������WiFiʧ�� )
call :ics on
@echo %msg%
@echo.
@echo ������ɰ���������ع���ѡ��
call :EndDateAndTime
::@pause >nul
timeout /t 5
@goto ya

:a5
@title �鿴 ��������״̬
@cls
call :BeginDateAndTime
@echo.
@echo �ȴ���������ɰ���������ع���ѡ�񣡡������˳���
@echo.
::if defined ssidv if [%ssidv%] neq [] set msg1=����WiFi����ʾ���ƣ�%ssidv%
::if defined keyv if [%keyv%] neq [] set msg2=����WiFi�����룺%keyv%
::if defined ussidv if [%ussidv%] neq [] set msg1=����WiFi����ʾ���ƣ�%ussidv%
::if defined ukeyv if [%ukeyv%] neq [] set msg2=����WiFi�����룺%ukeyv%
::if defined msg1 echo %msg1%
::if defined msg1 echo %msg2%
if defined ssidv if [%ssidv%] neq [] echo ����WiFi����ʾ���ƣ�%ssidv%
if defined keyv if [%keyv%] neq [] echo ����WiFi�����룺%keyv%
@netsh wlan show hostednetwork
if %errorlevel%==0 ( set msg=�鿴��������״̬�ɹ� ) else ( set msg=�鿴��������״̬ʧ�� )
@echo.
@echo %msg%
@echo.
@echo ������ɰ���������ع���ѡ��
::@pause >nul
call :EndDateAndTime
pause
@goto ya

:a6
@title �ر� WiFi �ȵ㹲��
@cls
call :BeginDateAndTime
@echo.
@echo �ȴ���������ɰ���������ع���ѡ�񣡡������˳���
@echo.
@echo ����WiFi �ر���...
@echo.
::call :ics off
@netsh wlan stop hostednetwork
if %errorlevel%==0 ( set msg=�ر�����WiFi�ɹ� ) else ( set msg=�ر�����WiFiʧ�� )
@echo %msg%
@echo.
@echo ������ɰ���������ع���ѡ��
call :EndDateAndTime
::@pause >nul
timeout /t 5
@goto ya

:a7
@title ���� WiFi �ȵ㹲��
@cls
call :BeginDateAndTime
@echo.
@echo �ȴ���������ɰ���������ع���ѡ�񣡡������˳���
@echo.
@echo ����WiFi �ر���...
@echo.
@netsh wlan stop hostednetwork
if %errorlevel%==0 ( set msg=�ر�����WiFi�ɹ� ) else ( set msg=�ر�����WiFiʧ�� )
@echo %msg%
@echo.
@echo ����WiFi ������...
@echo.
@netsh wlan start hostednetwork
if %errorlevel%==0 ( set msg=��������WiFi�ɹ� ) else ( set msg=��������WiFiʧ�� )
@echo %msg%
@echo.
@echo ������ɰ���������ع���ѡ��
call :EndDateAndTime
::@pause >nul
timeout /t 5
@goto ya

:kk
@title ���� WiFi �ȵ㹲��
@cls
call :BeginDateAndTime
@echo.
@echo �ȴ���������ɰ�Ctrl + C�˳����������˳���
@echo.
@echo ����WiFi �ر���...
@echo.
@netsh wlan stop hostednetwork
if %errorlevel%==0 ( set msg=�ر�����WiFi�ɹ� ) else ( set msg=�ر�����WiFiʧ�� )
@echo %msg%
@echo.
@echo ����WiFi ������...
@echo.
@netsh wlan start hostednetwork
if %errorlevel%==0 ( set msg=��������WiFi�ɹ� ) else ( set msg=��������WiFiʧ�� &goto :kk)
@echo %msg%
@echo.
@echo ������ɰ���������� WiFi �ȵ㹲��
@echo ������ɰ�Ctrl + C�˳���
call :EndDateAndTime
::@pause >nul
timeout /t 600
@goto :kk

:a4
@title ���� WiFi �ȵ㹲�������
@cls
@echo. %msg%
@echo.
@echo 1. ��������WiFi����ʾ����
@echo.
@echo 2. ��������WiFi������
@echo.
@echo 3. �����Զ����� WiFi �ȵ㹲��
@echo.
@echo 4. ȡ�������Զ����� WiFi �ȵ㹲��
@echo.
@echo 5. ���׹ر� WiFi �ȵ㹲��
@echo.
@echo 6. ���ع���ѡ��
@echo.
set msg=
	CHOICE /C 123456 /N /M "��ѡ�� [ 1 / 2 / 3 / 4 / 5 / 6 ]��"

	if %errorlevel%==1 goto :b1
	if %errorlevel%==2 goto :b2
	if %errorlevel%==3 goto :b3
	if %errorlevel%==4 goto :b4
	if %errorlevel%==5 goto :b5
	if %errorlevel%==6 goto :ya
goto :a4

:b1
@title ��������WiFi����ʾ����
@cls
@echo.
@echo �ȴ���������ɰ���������ع���ѡ�񣡡������˳���
@echo.
:b11
@set /p ssidv="����������WiFi����ʾ����(quit����):"%ssidv%
if [%ssidv%]==[] goto b11
if /I [%ssidv%]==[quit] goto a4
call :BeginDateAndTime
@echo.
@echo �����������WiFi����ʾ���ƣ�%ssidv%
@netsh wlan set hostednetwork ssid=%ssidv%
if %errorlevel%==0 ( set msg=��������WiFi����ʾ���Ƴɹ� ) else ( set msg=��������WiFi����ʾ����ʧ�� )
@echo %msg%
call :EndDateAndTime
@echo ������ɰ���������ع���ѡ��
::@pause >nul
timeout /t 5
@goto a4

:b2
@title ��������WiFi������
@cls
@echo.
@echo �ȴ���������ɰ�������˳����򣡡������˳���
@echo.
:b21
@set /p keyv="����������WiFi������(8λ����)(quit����):"%keyv%
if [%keyv%]==[] goto b21
if [%keyv%]==[quit] goto a4
call :count %keyv%
::echo �������ַ���str����%num%���ַ�
if %num% lss 8 (echo �����������С��8λ�����������롣 &&goto b21)
call :BeginDateAndTime
@echo.
@echo �����������WiFi�����룺%keyv%
@netsh wlan set hostednetwork key=%keyv% keyusage=persistent

if %errorlevel%==0 ( set msg=��������WiFi������ɹ� ) else ( set msg=��������WiFi������ʧ�� )
@echo %msg%
call :EndDateAndTime
@echo ������ɰ���������ع���ѡ��
::@pause >nul
timeout /t 5
@goto a4

:b3
@title �����Զ����� WiFi �ȵ㹲��
@cls
@echo.
@echo �ȴ���������ɰ�������˳����򣡡������˳���
@echo.
call :BeginDateAndTime
echo.
SCHTASKS /Create /TN "WiFi �ȵ㹲��" /TR "netsh wlan start hostednetwork" /SC ONLOGON /RU SYSTEM /RL Highest /F >nul 2>&1
if %errorlevel%==0 ( set msg=�����Զ����� WiFi �ȵ㹲��ɹ� ) else ( set msg=�����Զ����� WiFi �ȵ㹲��ʧ�� )
@echo %msg%
call :EndDateAndTime
@echo ������ɰ���������ع���ѡ��
::@pause >nul
timeout /t 5
@goto a4

:b4
@title ȡ�������Զ����� WiFi �ȵ㹲��
@cls
@echo.
@echo �ȴ���������ɰ�������˳����򣡡������˳���
@echo.
call :BeginDateAndTime
echo.
SCHTASKS /Query /TN "WiFi �ȵ㹲��" /HRESULT >nul 2>&1
if %errorlevel%==-2147024894 set msg=ȡ�������Զ����� WiFi �ȵ㹲��ɹ� &goto :b41
SCHTASKS /Delete /TN "WiFi �ȵ㹲��" /F >nul 2>&1
if %errorlevel%==0 ( set msg=ȡ�������Զ����� WiFi �ȵ㹲��ɹ� ) else ( set msg=ȡ�������Զ����� WiFi �ȵ㹲��ʧ�� )
:b41
@echo %msg%
call :EndDateAndTime
@echo ������ɰ���������ع���ѡ��
::@pause >nul
timeout /t 5
@goto a4

:b5
@title ���׹ر� WiFi �ȵ㹲��
@cls
call :BeginDateAndTime
@echo.
@echo �ȴ���������ɰ���������ع���ѡ�񣡡������˳���
@echo.
@echo ����WiFi �ر���...
@echo.
call :ics off
@netsh wlan stop hostednetwork
netsh wlan set hostednetwork mode=disallow
if %errorlevel%==0 ( set msg=�ر�����WiFi�ɹ� ) else ( set msg=�ر�����WiFiʧ�� )
SCHTASKS /Delete /TN "WiFi �ȵ㹲��" /F >nul 2>&1
@echo %msg%
@echo.
@echo ������ɰ���������ع���ѡ��
call :EndDateAndTime
::@pause >nul
timeout /t 5
@goto a4
:na
endlocal
popd
exit

:n77
::timeout /t 2
::for %%l in (Q,W,E,R,T,Y,U,I,O,P,L,K,J,H,G,F,D,S,A,Z,X,C,V,B,N,M) do if exist %%l: net share %%l$ /delete >nul
::net share admin$ /delete >nul
::net share ipc$ /delete >nul
FOR /F "skip=4 eol=�� DELIMS= " %%l IN ('net share') DO net share %%l /delete >nul
exit /B

:BeginDateAndTime
set start=%time%
SET startdate=%date%
FOR /F "DELIMS=" %%T IN ('TIME /T') DO SET starttime=%%T
SET @HOUR=%starttime:~0,2%
SET @SUFFIX=%starttime:~5,1%
IF /I "%@SUFFIX%"=="A" IF %@HOUR% EQU 12 SET @HOUR=00
IF /I "%@SUFFIX%"=="P" IF %@HOUR% LSS 12 SET /A @HOUR=%@HOUR% + 12
SET @NOW=%@HOUR%%starttime:~3,2%
SET @NOW=%@NOW: =0%
set Year=
for /f "skip=2" %%x in ('wmic Path Win32_LocalTime get Year^,Month^,Day^,Hour^,Minute^,Second /Format:List') do (
  if not defined Year set %%x
)
if %Hour% LSS 12 (
  set ampm=AM
  if %Hour%==0 set Hour=12
) else (
  set ampm=PM
  set /a Hour-=12
)
if %Minute% LSS 10 set Minute=0%Minute%
if %Hour% LSS 10 set Hour=0%Hour%
if %Second% LSS 10 set Second=0%Second%
set StartTimestamp=%Hour%:%Minute%:%Second% %ampm%
SET StartTimestamp1=%time:~0,2%:%time:~3,2%:%Second%
echo ���̿�ʼ�� %startdate% // %StartTimestamp% -- %StartTimestamp1% //
exit /B

:EndDateAndTime
set end=%time%
set options="tokens=1-4 delims=:."
for /f %options% %%a in ("%start%") do set start_h=%%a&set /a start_m=100%%b %% 100&set /a start_s=100%%c %% 100&set /a start_ms=100%%d %% 100
for /f %options% %%a in ("%end%") do set end_h=%%a&set /a end_m=100%%b %% 100&set /a end_s=100%%c %% 100&set /a end_ms=100%%d %% 100
set /a hours=%end_h%-%start_h%
set /a mins=%end_m%-%start_m%
set /a secs=%end_s%-%start_s%
set /a ms=%end_ms%-%start_ms%
if %hours% lss 0 set /a hours = 24%hours%
if %mins% lss 0 set /a hours = %hours% - 1 & set /a mins = 60%mins%
if %secs% lss 0 set /a mins = %mins% - 1 & set /a secs = 60%secs%
if %ms% lss 0 set /a secs = %secs% - 1 & set /a ms = 100%ms%
if 1%ms% lss 100 set ms=0%ms%
set /a totalsecs = %hours%*3600 + %mins%*60 + %secs% 
SET enddate=%date%
FOR /F "DELIMS=" %%T IN ('TIME /T') DO SET endtime=%%T
SET @HOUR=%endtime:~0,2%
SET @SUFFIX=%endtime:~5,1%
IF /I "%@SUFFIX%"=="A" IF %@HOUR% EQU 12 SET @HOUR=00
IF /I "%@SUFFIX%"=="P" IF %@HOUR% LSS 12 SET /A @HOUR=%@HOUR% + 12
SET @NOW=%@HOUR%%endtime:~3,2%
SET @NOW=%@NOW: =0%
set Year=
for /f "skip=2" %%x in ('wmic Path Win32_LocalTime get Year^,Month^,Day^,Hour^,Minute^,Second /Format:List') do (
  if not defined Year set %%x
)
if %Hour% LSS 12 (
  set ampm=AM
  if %Hour%==0 set Hour=12
) else (
  set ampm=PM
  set /a Hour-=12
)
if %Minute% LSS 10 set Minute=0%Minute%
if %Hour% LSS 10 set Hour=0%Hour%
if %Second% LSS 10 set Second=0%Second%
set EndTimestamp=%Hour%:%Minute%:%Second% %ampm%
SET EndTimestamp1=%time:~0,2%:%time:~3,2%:%Second%
echo:
echo ��������� %date% // %EndTimestamp% -- %EndTimestamp1% //
IF %mins% GEQ 1 (
goto :WithMinutes
) else ( 
goto :WithoutMinutes
)
:WithMinutes
echo ���̺�ʱ %mins%����%secs%�루����%totalsecs%�룩��
goto :End
:WithoutMinutes
echo ���̺�ʱ %totalsecs% �롣
:End
exit /B

:ics
call :icsvbs
::echo wmic path Win32_NetworkAdapter where Name^="Microsoft �й���������������" Get NetConnectionID ^/Format:List >"%temp%\dump1.cmd"
::for /f "skip=1" %x in ('wmic path Win32_NetworkAdapter where Name^="Microsoft �й���������������" Get NetConnectionID') do (echo "%x")
::if %OSType% EQU Win8 for /f "delims== tokens=2" %%x in ('"wmic path Win32_NetworkAdapter where (ProductName="Microsoft �й���������������" AND NetEnabled="TRUE") Get NetConnectionID /Format:List"') do set NetConnectionID=%%x
::if %OSType% EQU Win7 for /f "delims== tokens=2" %%x in ('"wmic path Win32_NetworkAdapter where (ProductName="Microsoft Virtual WiFi Miniport Adapter" AND NetEnabled="TRUE") Get NetConnectionID /Format:List"') do set NetConnectionID=%%x
for /f "delims== tokens=2" %%x in ('"wmic path Win32_NetworkAdapter where (ServiceName="vwifimp" AND NetEnabled="TRUE" AND Speed ^<^> "9223372036854775807") Get NetConnectionID /Format:List"') do set NetConnectionID=%%x
::del /f /q "%temp%\dump1.cmd"
::set ics1=��������* %DeviceID%
::for /f "delims== tokens=2" %%o in ('"wmic path Win32_NetworkAdapter where (Manufacturer ^<^> "Microsoft" AND NetEnabled="TRUE") Get NetConnectionID /Format:List"') do cscript //nologo "%temp%\ics.vbs" "%NetConnectionID%" "%%o" "%1" >nul 2>&1
::for /f "delims== tokens=2" %%o in ('"wmic path Win32_NetworkAdapter where (Manufacturer ^<^> "Microsoft" AND NetEnabled="TRUE") Get NetConnectionID /Format:List"') do set NetConnectionID2=%%o
for /f "tokens=1" %%o in ('"wmic path Win32_NetworkAdapter where (NetEnabled="TRUE") Get NetConnectionID,PNPDeviceID |findstr PCI\VEN"') do set NetConnectionID2=%%o
cscript //nologo "%temp%\ics.vbs" "%NetConnectionID%" "%NetConnectionID2%" "%1" >nul 2>&1
del /f /q "%temp%\ics.vbs"
exit /B

:count
set "str=%*"
set /a max=8190,min=0
for /l %%a in (1,1,14) do (
     set /a "num=(max+min)/2"
     for /f "delims=" %%b in ("!num!") do if "!str:~%%b!" equ "" (set /a max=num) else set /a min=num
)
if "!str:~%num%!" neq "" set /a num+=1
exit /B

:icsvbs
echo ' VBScript source code>"%temp%\ics.vbs"
echo OPTION EXPLICIT>>"%temp%\ics.vbs"
echo DIM ICSSC_DEFAULT, CONNECTION_PUBLIC, CONNECTION_PRIVATE, CONNECTION_ALL>>"%temp%\ics.vbs"
echo DIM NetSharingManager>>"%temp%\ics.vbs"
echo DIM PublicConnection, PrivateConnection>>"%temp%\ics.vbs"
echo DIM EveryConnectionCollection>>"%temp%\ics.vbs"
echo DIM objArgs>>"%temp%\ics.vbs"
echo DIM priv_con, publ_con>>"%temp%\ics.vbs"
echo dim switch>>"%temp%\ics.vbs"
echo ICSSC_DEFAULT ^=^ ^0>>"%temp%\ics.vbs"
echo CONNECTION_PUBLIC ^=^ ^0>>"%temp%\ics.vbs"
echo CONNECTION_PRIVATE ^=^ ^1>>"%temp%\ics.vbs"
echo CONNECTION_ALL ^=^ ^2>>"%temp%\ics.vbs"
echo Main()>>"%temp%\ics.vbs"
echo sub Main( )>>"%temp%\ics.vbs"
echo Set objArgs ^= WScript.Arguments>>"%temp%\ics.vbs"
echo if objArgs.Count ^= 3 then>>"%temp%\ics.vbs"
echo priv_con ^= objArgs(0)'����������>>"%temp%\ics.vbs"
echo publ_con ^= objArgs(1)'����������>>"%temp%\ics.vbs"
echo switch ^= objArgs(2)'״̬�л����� on Ϊ ��ics off �෴>>"%temp%\ics.vbs"
echo if Initialize() ^= TRUE then>>"%temp%\ics.vbs"
echo GetConnectionObjects()>>"%temp%\ics.vbs"
echo FirewallTestByName priv_con,publ_con>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo else>>"%temp%\ics.vbs"
echo DIM szMsg>>"%temp%\ics.vbs"
echo if Initialize() ^= TRUE then>>"%temp%\ics.vbs"
echo GetConnectionObjects()>>"%temp%\ics.vbs"
echo FirewallTestByName "list","list">>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo szMsg ^= "To share your internet connection, please provide the name of the private and public connections as the argument." ^& vbCRLF ^& vbCRLF ^& _>>"%temp%\ics.vbs"
echo "Usage:" ^& vbCRLF ^& _>>"%temp%\ics.vbs"
echo " " ^& WScript.scriptname ^& " " ^& chr(34) ^& "Private Connection Name" ^& chr(34) ^& " " ^& chr(34) ^& "Public Connection Name" ^& chr(34)>>"%temp%\ics.vbs"
echo WScript.Echo( szMsg ^& vbCRLF ^& vbCRLF)>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo end sub>>"%temp%\ics.vbs"
echo sub FirewallTestByName(con1,con2)>>"%temp%\ics.vbs"
echo on error resume next>>"%temp%\ics.vbs"
echo DIM Item>>"%temp%\ics.vbs"
echo DIM EveryConnection>>"%temp%\ics.vbs"
echo DIM objNCProps>>"%temp%\ics.vbs"
echo DIM szMsg>>"%temp%\ics.vbs"
echo DIM bFound1,bFound2>>"%temp%\ics.vbs"
echo WScript.echo(vbCRLF ^& vbCRLF)>>"%temp%\ics.vbs"
echo bFound1 ^= false>>"%temp%\ics.vbs"
echo bFound2 ^= false>>"%temp%\ics.vbs"
echo for each Item in EveryConnectionCollection>>"%temp%\ics.vbs"
echo set EveryConnection ^= NetSharingManager.INetSharingConfigurationForINetConnection(Item)>>"%temp%\ics.vbs"
echo set objNCProps ^= NetSharingManager.NetConnectionProps(Item)>>"%temp%\ics.vbs"
echo szMsg ^= "Name: " ^& objNCProps.Name ^& vbCRLF ^& _>>"%temp%\ics.vbs"
echo "Guid: " ^& objNCProps.Guid ^& vbCRLF ^& _>>"%temp%\ics.vbs"
echo "DeviceName: " ^& objNCProps.DeviceName ^& vbCRLF ^& _>>"%temp%\ics.vbs"
echo "Status: " ^& objNCProps.Status ^& vbCRLF ^& _>>"%temp%\ics.vbs"
echo "MediaType: " ^& objNCProps.MediaType>>"%temp%\ics.vbs"
echo if EveryConnection.SharingEnabled then>>"%temp%\ics.vbs"
echo szMsg ^= szMsg ^& vbCRLF ^& _>>"%temp%\ics.vbs"
echo "SharingEnabled" ^& vbCRLF ^& _>>"%temp%\ics.vbs"
echo "SharingType: " ^& ConvertConnectionTypeToString(EveryConnection.SharingConnectionType)>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo if objNCProps.Name ^= con1 then>>"%temp%\ics.vbs"
echo bFound1 ^= true>>"%temp%\ics.vbs"
echo if EveryConnection.SharingEnabled ^= False and switch^="on" then>>"%temp%\ics.vbs"
echo szMsg ^= szMsg ^& vbCRLF ^& "Not Shared... Enabling private connection share...">>"%temp%\ics.vbs"
echo WScript.Echo(szMsg)>>"%temp%\ics.vbs"
echo EveryConnection.EnableSharing CONNECTION_PRIVATE>>"%temp%\ics.vbs"
echo szMsg ^= " Shared!">>"%temp%\ics.vbs"
echo elseif(switch ^= "off") then>>"%temp%\ics.vbs"
echo szMsg ^= szMsg ^& vbCRLF ^& "Shared... DisEnabling private connection share...">>"%temp%\ics.vbs"
echo WScript.Echo(szMsg)>>"%temp%\ics.vbs"
echo EveryConnection.EnableSharing CONNECTION_ALL>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo if objNCProps.Name ^= con2 then>>"%temp%\ics.vbs"
echo bFound2 ^= true>>"%temp%\ics.vbs"
echo if EveryConnection.SharingEnabled ^= False and switch^="on" then>>"%temp%\ics.vbs"
echo szMsg ^= szMsg ^& vbCRLF ^& "Not Shared... Enabling public connection share...">>"%temp%\ics.vbs"
echo WScript.Echo(szMsg)>>"%temp%\ics.vbs"
echo EveryConnection.EnableSharing CONNECTION_PUBLIC>>"%temp%\ics.vbs"
echo szMsg ^= " Shared!">>"%temp%\ics.vbs"
echo elseif(switch ^= "off") then>>"%temp%\ics.vbs"
echo szMsg ^= szMsg ^& vbCRLF ^& "Shared... DisEnabling public connection share...">>"%temp%\ics.vbs"
echo WScript.Echo(szMsg)>>"%temp%\ics.vbs"
echo EveryConnection.EnableSharing CONNECTION_ALL>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo WScript.Echo(szMsg ^& vbCRLF ^& vbCRLF)>>"%temp%\ics.vbs"
echo next>>"%temp%\ics.vbs"
echo if( con1 ^<^> "list" ) then>>"%temp%\ics.vbs"
echo if( bFound1 ^= false ) then>>"%temp%\ics.vbs"
echo WScript.Echo( "Connection " ^& chr(34) ^& con1 ^& chr(34) ^& " was not found" )>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo if( bFound2 ^= false ) then>>"%temp%\ics.vbs"
echo WScript.Echo( "Connection " ^& chr(34) ^& con2 ^& chr(34) ^& " was not found" )>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo end sub>>"%temp%\ics.vbs"
echo function Initialize()>>"%temp%\ics.vbs"
echo DIM bReturn>>"%temp%\ics.vbs"
echo bReturn ^= FALSE>>"%temp%\ics.vbs"
echo set NetSharingManager ^= Wscript.CreateObject("HNetCfg.HNetShare.1")>>"%temp%\ics.vbs"
echo if (IsObject(NetSharingManager)) ^= FALSE then>>"%temp%\ics.vbs"
echo Wscript.Echo("Unable to get the HNetCfg.HnetShare.1 object")>>"%temp%\ics.vbs"
echo else>>"%temp%\ics.vbs"
echo if (IsNull(NetSharingManager.SharingInstalled) ^= TRUE) then>>"%temp%\ics.vbs"
echo Wscript.Echo("Sharing isn't available on this platform.")>>"%temp%\ics.vbs"
echo else>>"%temp%\ics.vbs"
echo bReturn ^= TRUE>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo Initialize ^= bReturn>>"%temp%\ics.vbs"
echo end function>>"%temp%\ics.vbs"
echo function GetConnectionObjects()>>"%temp%\ics.vbs"
echo DIM bReturn>>"%temp%\ics.vbs"
echo DIM Item>>"%temp%\ics.vbs"
echo bReturn ^= TRUE>>"%temp%\ics.vbs"
echo if GetConnection(CONNECTION_PUBLIC) ^= FALSE then>>"%temp%\ics.vbs"
echo bReturn ^= FALSE>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo if GetConnection(CONNECTION_PRIVATE) ^= FALSE then>>"%temp%\ics.vbs"
echo bReturn ^= FALSE>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo if GetConnection(CONNECTION_ALL) ^= FALSE then>>"%temp%\ics.vbs"
echo bReturn ^= FALSE>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo GetConnectionObjects ^= bReturn>>"%temp%\ics.vbs"
echo end function>>"%temp%\ics.vbs"
echo function GetConnection(CONNECTION_TYPE)>>"%temp%\ics.vbs"
echo DIM bReturn>>"%temp%\ics.vbs"
echo DIM Connection>>"%temp%\ics.vbs"
echo DIM Item>>"%temp%\ics.vbs"
echo bReturn ^= TRUE>>"%temp%\ics.vbs"
echo if (CONNECTION_PUBLIC ^= CONNECTION_TYPE) then>>"%temp%\ics.vbs"
echo set Connection ^= NetSharingManager.EnumPublicConnections(ICSSC_DEFAULT)>>"%temp%\ics.vbs"
echo if (Connection.Count ^> 0) and (Connection.Count ^< 2) then>>"%temp%\ics.vbs"
echo for each Item in Connection>>"%temp%\ics.vbs"
echo set PublicConnection ^= NetSharingManager.INetSharingConfigurationForINetConnection(Item)>>"%temp%\ics.vbs"
echo next>>"%temp%\ics.vbs"
echo else>>"%temp%\ics.vbs"
echo bReturn ^= FALSE>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo elseif (CONNECTION_PRIVATE ^= CONNECTION_TYPE) then>>"%temp%\ics.vbs"
echo set Connection ^= NetSharingManager.EnumPrivateConnections(ICSSC_DEFAULT)>>"%temp%\ics.vbs"
echo if (Connection.Count ^> 0) and (Connection.Count ^< 2) then>>"%temp%\ics.vbs"
echo for each Item in Connection>>"%temp%\ics.vbs"
echo set PrivateConnection ^= NetSharingManager.INetSharingConfigurationForINetConnection(Item)>>"%temp%\ics.vbs"
echo next>>"%temp%\ics.vbs"
echo else>>"%temp%\ics.vbs"
echo bReturn ^= FALSE>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo elseif (CONNECTION_ALL ^= CONNECTION_TYPE) then>>"%temp%\ics.vbs"
echo set Connection ^= NetSharingManager.EnumEveryConnection>>"%temp%\ics.vbs"
echo if (Connection.Count ^> 0) then>>"%temp%\ics.vbs"
echo set EveryConnectionCollection ^= Connection>>"%temp%\ics.vbs"
echo else>>"%temp%\ics.vbs"
echo bReturn ^= FALSE>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo else>>"%temp%\ics.vbs"
echo bReturn ^= FALSE>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo if (TRUE ^= bReturn) then>>"%temp%\ics.vbs"
echo if (Connection.Count ^= 0) then>>"%temp%\ics.vbs"
echo Wscript.Echo("No " ^+ CStr(ConvertConnectionTypeToString(CONNECTION_TYPE)) ^+ " connections exist (Connection.Count gave us 0)")>>"%temp%\ics.vbs"
echo bReturn ^= FALSE>>"%temp%\ics.vbs"
echo 'valid to have more than 1 connection returned from EnumEveryConnection>>"%temp%\ics.vbs"
echo elseif (Connection.Count ^> 1) and (CONNECTION_ALL ^<^> CONNECTION_TYPE) then>>"%temp%\ics.vbs"
echo Wscript.Echo("ERROR: There was more than one " ^+ ConvertConnectionTypeToString(CONNECTION_TYPE) ^+ " connection (" ^+ CStr(Connection.Count) ^+ ")")>>"%temp%\ics.vbs"
echo bReturn ^= FALSE>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo Wscript.Echo(CStr(Connection.Count) ^+ " objects for connection type " ^+ ConvertConnectionTypeToString(CONNECTION_TYPE))>>"%temp%\ics.vbs"
echo GetConnection ^= bReturn>>"%temp%\ics.vbs"
echo end function>>"%temp%\ics.vbs"
echo function ConvertConnectionTypeToString(ConnectionID)>>"%temp%\ics.vbs"
echo DIM ConnectionString>>"%temp%\ics.vbs"
echo if (ConnectionID ^= CONNECTION_PUBLIC) then>>"%temp%\ics.vbs"
echo ConnectionString ^= "public">>"%temp%\ics.vbs"
echo elseif (ConnectionID ^= CONNECTION_PRIVATE) then>>"%temp%\ics.vbs"
echo ConnectionString ^= "private">>"%temp%\ics.vbs"
echo elseif (ConnectionID ^= CONNECTION_ALL) then>>"%temp%\ics.vbs"
echo ConnectionString ^= "all">>"%temp%\ics.vbs"
echo else>>"%temp%\ics.vbs"
echo ConnectionString ^= "Unknown: " ^+ CStr(ConnectionID)>>"%temp%\ics.vbs"
echo end if>>"%temp%\ics.vbs"
echo ConvertConnectionTypeToString ^= ConnectionString>>"%temp%\ics.vbs"
echo end function>>"%temp%\ics.vbs"
exit /B

:CheckVersion
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G
if %winbuild% GEQ 9200 (
    set OSType=Win8
) else if %winbuild% GEQ 7600 (
    set OSType=Win7
) else (
    goto :UnsupportedVersion
)
exit /B

:UnsupportedVersion
echo ==== ���� ====
echo ��⵽��֧�ֵĲ���ϵͳ�汾��
echo ����Ŀֻ֧�� Windows7/8/8.1��
exit
