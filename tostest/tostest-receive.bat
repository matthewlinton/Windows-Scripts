@ECHO off
@REM tostest-receive
@REM track ToS info of scanned packets
@REM Updated 2008-03-18

ECHO This script is not yet functional
PAUSE
EXIT 1

IF NOT EXIST Lib\WinDump.exe ECHO Windump.exe not found. Cannot continue. & EXIT 1

:SETUP
SET LOGFILE=logfile
SET INTERFACE=0

SET /P LOGFILE=Enter in a log name (w/o extension): 
IF EXIST "%LOGFILE%-BE.log" GOTO OVERWRITELOG
:CONTINUE
ECHO Available Interfaces:
ECHO ---------------------------------------------------
Lib\WinDump.exe -D
ECHO ---------------------------------------------------
SET /P INTERFACE=Enter the number of the interface to use: 

:STARTCAP
START /MIN qostest-cap.bat %INTERFACE% "%LOGFILE%-capture.log"
ECHO.
ECHO Press any key when done capturing packets...
PAUSE > NUL

:PARSELOGS
REM TODO: analise capture log

:CLEANUP
ECHO Cleaning up...
taskkill /IM WinDump.exe /T /F

:END
ECHO Done
PAUSE
EXIT 0

:OVERWRITELOG
SET ANS=n
ECHO ** "%LOGFILE%" already exists.  Would you like to overwrite this file?
SET /P ANS=   (y/N): 
IF "%ANS%"=="n" GOTO SETUP
IF "%ANS%"=="N" GOTO SETUP
IF "%ANS%"=="y" DEL "%LOGFILE%*" & GOTO CONTINUE
IF "%ANS%"=="Y" DEL "%LOGFILE%" & GOTO CONTINUE
ECHO    "%ANS%" is not valid
EXIT 1