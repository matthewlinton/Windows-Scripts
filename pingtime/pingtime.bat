@ECHO off
@REM pingtime
@REM Logs ping attempts to a host
@REM Updated 2008-01-16

IF NOT EXIST Lib\tail.exe ECHO tail.exe not found. Unable to continue. & EXIT 1
IF NOT EXIST Lib\sed.exe ECHO sed.exe not found. Unable to continue. & EXIT 1
IF NOT EXIST Lib\gawk.exe ECHO gawk.exe not found. Unable to continue. & EXIT 1
IF NOT EXIST Lib\wait.exe ECHO wait.exe not found.  pingtime will not wait between pings.

:SETUP
SET LOGFILE=logfile
SET PINGHOST=192.168.2.1
SET WAITTIME=5
SET NUMPINGS=1

SET /P LOGFILE=Enter in a log name (w/o extension): 
IF EXIST "%LOGFILE%.csv" GOTO OVERWRITELOG
:CONTINUE
SET /P PINGHOST=Enter in the host to ping: 
SET /P WAITTIME=Enter a duration between Pings in seconds (%WAITTIME%): 

ECHO -----------------------------------------------
ECHO pinging %PINGHOST% every %WAITTIME% second(s).
ECHO logging results to "%LOGFILE%.csv"
ECHO press CTRL+C to stop
ECHO -----------------------------------------------

ECHO Date,Time,Ping Result > "%LOGFILE%.csv"

:START
<NUL (SET/p anyvariable=%DATE%,%TIME%,) >  "%LOGFILE%.tmp"
ping -n %NUMPINGS% %PINGHOST% | Lib\grep.exe -U "^[RDH]"  >> "%LOGFILE%.tmp"
Lib\sed.exe -T "s/,$/,Unable to resolve host\n/g" "%LOGFILE%.tmp" >> "%LOGFILE%.csv"
Lib\tail.exe -n 1 "%LOGFILE%.csv" | Lib\gawk.exe "BEGIN {FS=\",\"} ; {print $3}"
IF EXIST Lib\wait.exe Lib\wait.exe %WAITTIME%
GOTO START

:END
DEL "%LOGFILE%.tmp"
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
GOTO END