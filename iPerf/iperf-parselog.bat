@echo off
@REM iperf-parselog
@REM If iperf-client fails to complete; this script can take the raw log file and convert it to a CSV file
@REM Updated 2008-01-07

:SETUP
SET LOGFILE=logfile
SET GREPCMD="Mbits/sec$"
SET SEDCMD="s/sec//g; s/MBytes//g; s#Mbits/##g; s/-[ ]/-/g; s/[ ]\+/,/g; s/$/\r/g"

set /P LOGFILE=Enter in the log file name (w/o extension): 
IF NOT EXIST "%LOGFILE%.log" ECHO "%LOGFILE%.log" does not exist. & GOTO SETUP
IF EXIST "%LOGFILE%.csv" GOTO OVERWRITELOG
:CONTINUE

Lib\grep.exe %GREPCMD% "%LOGFILE%.log" >> "%LOGFILE%.tmp"
echo [ID],Interval (s),Transfer (MBytes),Bandwidth (Mbits/sec) > "%LOGFILE%.csv"
Lib\sed.exe %SEDCMD% "%LOGFILE%.tmp" >> "%LOGFILE%.CSV"
DEL "%LOGFILE%.tmp"

:END
echo DONE
pause
EXIT 0

:OVERWRITELOG
SET ANS=n
ECHO ** "%LOGFILE%.csv" already exists.  Would you like to overwrite this file?
SET /P ANS=   (y/N): 
IF "%ANS%"=="n" GOTO SETUP
IF "%ANS%"=="N" GOTO SETUP
IF "%ANS%"=="y" del "%LOGFILE%.log" & GOTO CONTINUE
IF "%ANS%"=="Y" del "%LOGFILE%.log" & GOTO CONTINUE
ECHO    "%ANS%" is not valid
GOTO END