@ECHO off
@REM tostest-send
@REM generates packets to test QoS
@REM Updated 2008-03-28

IF NOT EXIST "%PROGRAMFILES%\WinPcap\rpcapd.exe" ECHO WinPcap is not installed.  Unable to continue. & EXIT 1
IF NOT EXIST Lib\npg.exe ECHO npg.exe not found. Unable to continue. & EXIT 1
IF NOT EXIST Lib\grep.exe ECHO grep.exe not found. Unable to continue. & EXIT 1
IF NOT EXIST Lib\sed.exe ECHO sed.exe not found. Unable to continue. & EXIT 1
IF NOT EXIST Lib\gawk.exe ECHO gawk.exe not found. Unable to continue. & EXIT 1

:SETUP
SET LOGFILE=logfile
SET TEMPFILE=temp
SET CONFDIR=Conf
SET CONFFILE=%CONFDIR%\MasterTest.conf
SET RUNFILE=runfile.txt
SET SOURCEIP=127.0.0.1
SET SOURCENET=127.0.0
SET SOURCEMAC=00~00~00~00~00~00
SET DESTINIP=127.0.0.1
SET DESTINNET=127.0.0
SET DESTINMAC=00~00~00~00~00~00

SET /P LOGFILE=Enter in a log name (w/o extension): 
IF EXIST "%LOGFILE%.csv" GOTO OVERWRITELOG
:CONTINUE

SET /P DESTINIP=Enter the receiving host address: 

:FETCHINFO
@REM Fetch IP and MAC for local host
ipconfig | Lib\grep.exe "IP Address" | Lib\sed.exe -e "s/IP Address//g" -e "s/[ .]*: //g" | Lib\gawk.exe "BEGIN { FS=\".\" } ; { printf \"%%2X~%%2X~%%2X~%%2X\", $1, $2, $3, $4 }" | Lib\sed.exe -e "s/ /0/g"  > "%TEMPFILE%"
FOR /F %%I IN (%TEMPFILE%) DO SET SOURCEIP=%%I
ipconfig /all | Lib\grep.exe "Physical Address" | Lib\sed.exe -e "s/Physical Address//g" -e "s/[ .]*: //g" -e "s/-/~/g" > "%TEMPFILE%"
FOR /F %%I IN (%TEMPFILE%) DO SET SOURCEMAC=%%I
@REM Convert destination IP to hex values
ECHO %DESTINIP% | Lib\gawk.exe "BEGIN { FS=\".\" } ; { printf \"%%2X~%%2X~%%2X~%%2X\", $1, $2, $3, $4 }" | Lib\sed.exe -e "s/ /0/g"  > "%TEMPFILE%"
FOR /F %%I IN (%TEMPFILE%) DO SET DESTINIP=%%I
@REM Fetch gateway MAC address
ipconfig | Lib\grep.exe "Default Gateway" | Lib\sed.exe -e "s/Default Gateway//g" -e "s/[ .]*: //g" > "%TEMPFILE%"
FOR /F %%I IN (%TEMPFILE%) DO SET DEFAULTGATEWAY=%%I
PING -n 1 %DEFAULTGATEWAY% > NUL
arp -a | Lib\grep "%DEFAULTGATEWAY%" | Lib\gawk.exe "{ print toupper($2) }" | Lib\sed.exe -e "s/-/~/g" > "%TEMPFILE%"
FOR /F %%I IN (%TEMPFILE%) DO SET DESTINMAC=%%I
@REM Need to escape the backslashes in %INTERFACE%
ECHO %INTERFACE% > "%TEMPFILE%"
Lib\sed.exe -T -e "s#\\#\\\\#g" "%TEMPFILE%" > "%TEMPFILE%2"
FOR /F %%I IN (%TEMPFILE%2) DO SET INTERFACE=%%I

:GENERATESCRIPT
TYPE %CONFDIR%\*.scr > %CONFFILE%
Lib\sed.exe -T -e "s/::DESTINMAC::/%DESTINMAC%/g" -e "s/::DESTINIP::/%DESTINIP%/g" -e "s/::SOURCEMAC::/%SOURCEMAC%/g" -e "s/::SOURCEIP::/%SOURCEIP%/g" "%CONFFILE%" > "%TEMPFILE%"
Lib\sed.exe -T -e "s/~/ /g" "%TEMPFILE%" > "%RUNFILE%"

:RUNSCRIPT
ECHO.
Lib\npg.exe -vv -f "%RUNFILE%"
ECHO.

:END
DEL "%TEMPFILE%*"
ECHO Done
PAUSE
EXIT 0

:OVERWRITELOG
SET ANS=n
ECHO ** "%LOGFILE%.csv" already exists.  Would you like to overwrite this file?
SET /P ANS=   (y/N): 
IF "%ANS%"=="n" GOTO SETUP
IF "%ANS%"=="N" GOTO SETUP
IF "%ANS%"=="y" DEL "%LOGFILE%.csv" & GOTO CONTINUE
IF "%ANS%"=="Y" DEL "%LOGFILE%.csv" & GOTO CONTINUE
ECHO    "%ANS%" is not valid
EXIT 1