@ECHO off
@REM iperf-client
@REM Connects to the iperf-server host and begins data transfer.
@REM Updated 2008-02-13

IF NOT EXIST Lib\iperf.exe ECHO could NOT find iperf.exe. Unable to continue & exit 1
IF NOT EXIST Lib\grep.exe ECHO could NOT find grep.exe. A CSV log will not be generated.
IF NOT EXIST Lib\sed.exe ECHO could NOT find sed.exe. A CSV log will not be generated.

:SETUP
SET SERVER="localhost"
SET PORT=5001
SET TCPWIN="128k"
SET FORMAT="m"
SET INTERVAL=15
SET TESTLEN=1
SET UDP=n
SET LOGFILE=logfile
SET GREPCMD="Mbits/sec$"
SET SEDCMD="s/sec//g; s/MBytes//g; s#Mbits/##g; s/-[ ]/-/g; s/[ ]\+/,/g; s/$/\r/g"

SET /P LOGFILE=Enter in a logfile name (w/o extension): 
IF EXIST "%LOGFILE%.log" GOTO OVERWRITELOG
:CONTINUE
SET /P SERVER=Enter in the iPerf server's IP address: 
SET /P PORT=Enter a port to run on (%PORT%): 
SET /P UDP=Run UDP test (y/N): 
SET /P TESTLEN=Enter test duration in minutes (%TESTLEN%): 
SET /P INTERVAL=Enter the output interval in seconds (%INTERVAL%): 

SET /A TESTLEN *= 60

ECHO Test started on %DATE% %TIME%
start Lib\tail.exe -F "%LOGFILE%.log"
IF %UDP% == n Lib\iperf.exe -c %SERVER% -p %PORT% -d -w %TCPWIN% -f %FORMAT% -i %INTERVAL% -t %TESTLEN% >> "%LOGFILE%.log"
IF %UDP% == N Lib\iperf.exe -c %SERVER% -p %PORT% -d -w %TCPWIN% -f %FORMAT% -i %INTERVAL% -t %TESTLEN% >> "%LOGFILE%.log"
IF %UDP% == y Lib\iperf.exe -c %SERVER% -p %PORT% -d -u -w %TCPWIN% -f %FORMAT% -i %INTERVAL% -t %TESTLEN%  >> "%LOGFILE%.log"
IF %UDP% == Y Lib\iperf.exe -c %SERVER% -p %PORT% -d -u -w %TCPWIN% -f %FORMAT% -i %INTERVAL% -t %TESTLEN%  >> "%LOGFILE%.log"

IF EXIST Lib\grep.exe IF EXIST Lib\sed.exe GOTO PARSELOG

:END
ECHO Done
PAUSE
EXIT 0

:PARSELOG
Lib\grep.exe %GREPCMD% "%LOGFILE%.log" >> "%LOGFILE%.tmp"
ECHO [ID],Interval (s),Transfer (MBytes),Bandwidth (Mbits/sec) > "%LOGFILE%.csv"
Lib\sed.exe %SEDCMD% "%LOGFILE%.tmp" >> "%LOGFILE%.CSV"
del "%LOGFILE%.tmp"
GOTO END

:OVERWRITELOG
SET ANS=n
ECHO ** "%LOGFILE%.log" already exists.  Would you like to overwrite this file?
SET /P ANS=   (y/N): 
IF "%ANS%"=="n" GOTO SETUP
IF "%ANS%"=="N" GOTO SETUP
IF "%ANS%"=="y" del "%LOGFILE%.log" & GOTO CONTINUE
IF "%ANS%"=="Y" del "%LOGFILE%.log" & GOTO CONTINUE
ECHO    "%ANS%" is not valid
GOTO END