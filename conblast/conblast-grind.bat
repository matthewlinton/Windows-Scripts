@ECHO off
@REM conblast-grind
@REM open and close connections to a conblast server
@REM Updated 2008-05-13

IF NOT EXIST Lib\nc.exe ECHO nc.exe not found. unable to continue. & exit 1
IF NOT EXIST Lib\Wait.exe ECHO Wait.exe not found. conblast-grind will not wait between operations.

:INFO
ECHO *******************************************************************************
ECHO Some systems have trouble handling the large number of process and open ports
ECHO that this script generates. The Default maximum number of ports allowed has 
ECHO been SET at %MAXPORTS% and should work for most systems.
ECHO *******************************************************************************
pause

:SETUP
SET HOST=127.0.0.1
SET STARTPORT=1024
SET NUMPORTS=400
SET MAXPORTS=400
SET MINPORT=1024
SET WAITTIME=1
SET COUNT=0
SET TOTAL=0
SET LOGFILE=logfile

:CONFIG 
SET /P LOGFILE=Enter in the log file name (w/o extension):
IF EXIST "%LOGFILE%.csv" GOTO OVERWRITELOG
:CONTINUE
SET /P HOST=Enter the IP address of the NetCat server: 
:CONTINUEPORT
SET /P STARTPORT=Enter a starting port (%STARTPORT%): 
SET /P NUMPORTS=Enter in the number of ports to open (%NUMPORTS%): 
SET /P WAITTIME=Enter the time between opening ports (%WAITTIME%s): 

IF %NUMPORTS% GTR %MAXPORTS% ECHO Cannot open more than %MAXPORTS% ports. & GOTO CONTINUEPORT
IF %STARTPORT% LSS %MINPORT% ECHO Cannot open ports lower than %MINPORT%. & GOTO CONTINUEPORT
SET /A ENDPORT=%STARTPORT% + %NUMPORTS%
IF %ENDPORT% GTR 65535 ECHO Port range goes beyond maximum of 65535 ports & GOTO CONTINUEPORT

ECHO DATE,TIME,ROUND,CONNECTIONS > "%LOGFILE%.csv"

:INIT
SET /A COUNT += 1
SET /A TOTAL = %COUNT% * %NUMPORTS%
ECHO %DATE%,%TIME%,%COUNT%,%TOTAL% >> "%LOGFILE%.csv"
taskkill /IM nc.exe /T /F
SET CURRENTPORT=%STARTPORT%
SET LOOPPORTS=%NUMPORTS%

:LOOP
ECHO Attempting to connect to NetCat server (%HOST%) on port %CURRENTPORT%
start Lib\nc.exe -d %HOST% %CURRENTPORT%
SET /A CURRENTPORT += 1
SET /A LOOPPORTS -= 1
Lib\wait.exe %WAITTIME%
IF %LOOPPORTS% LSS 0 goto INIT
GOTO LOOP

:END
ECHO Done.
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