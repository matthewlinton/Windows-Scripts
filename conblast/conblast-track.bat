@ECHO off
@REM conblast-track
@REM Track the number of active connections on a host
@REM Updated 2008-01-14

IF NOT EXIST Lib\wc.exe ECHO wc.exe not found. Unable to continue. & EXIT 1
IF NOT EXIST Lib\grep.exe ECHO grep.exe not found. Unable to continue. & EXIT 1
IF NOT EXIST Lib\date.exe ECHO date.exe not found. Unable to continue. & EXIT 1
IF NOT EXIST Lib\tail.exe ECHO tail.exe not found. Unable to continue. & EXIT 1
IF NOT EXIST Lib\wait.exe ECHO wait.exe not found.  conblast-track will not wait between polling.

:SETUP
SET WAITTIME=1
SET LOGFILE=logfile

SET /P LOGFILE=Enter in a logfile name (w/o extension): 
IF EXIST "%LOGFILE%.csv" GOTO OVERWRITELOG
:CONTINUE
IF EXIST Lib\wait.exe SET /P WAITTIME=Enter the time between Poling in minutes(%WAITTIME%): 

ECHO Date,Time,Active Connections > "%LOGFILE%.csv"

SET /A WAITTIME *= 60
:LOOP
<nul (SET/p anyvariable=%DATE%,%TIME%,) >> "%LOGFILE%.csv"
netstat -n | Lib\grep.exe -U "ESTABLISHED" | Lib\wc.exe -l >> "%LOGFILE%.csv"
Lib\tail.exe -n 1 "%LOGFILE%.csv"
IF EXIST Lib\Wait.exe Lib\Wait.exe %WAITTIME%
GOTO LOOP

:END
ECHO DONE
pause
exit 0

:OVERWRITELOG
SET ANS=n
ECHO ** "%LOGFILE%.csv" already exists.  Would you like to overwrite this file?
SET /P ANS=   (y/N): 
IF "%ANS%"=="n" GOTO SETUP
IF "%ANS%"=="N" GOTO SETUP
IF "%ANS%"=="y" del "%LOGFILE%.csv" & GOTO CONTINUE
IF "%ANS%"=="Y" del "%LOGFILE%.csv" & GOTO CONTINUE
ECHO    "%ANS%" is not valid
GOTO END