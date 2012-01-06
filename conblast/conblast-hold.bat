@ECHO off
@REM conblast-client
@REM open a user defined number of ports to a conblast-server
@REM Updated 2008-01-07

IF NOT EXIST Lib\nc.exe ECHO nc.exe not found. unable to continue. & GOTO END

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

:CONFIG 
SET /P HOST=Enter the IP address of the NetCat server: 
SET /P STARTPORT=Enter a starting port (%STARTPORT%): 
SET /P NUMPORTS=Enter in the number of ports to open (%NUMPORTS%): 
SET /P WAITTIME=Enter the time between opening ports (%WAITTIME%s): 

IF %NUMPORTS% GTR %MAXPORTS% ECHO Cannot open more than %MAXPORTS% ports & GOTO CONFIG
ECHO beep
IF %STARTPORT% LSS %MINPORT% ECHO Cannot open ports lower than %MINPORT%. & GOTO CONFIG
ECHO beep
SET /A ENDPORT=%STARTPORT% + %NUMPORTS%
IF %ENDPORT% GTR 65535 ECHO Port range goes beyond maximum of 65535 ports & GOTO CONFIG

:LOOP
ECHO Attempting to connect to NetCat server (%HOST%) on port %STARTPORT%
start Lib\nc.exe -d %HOST% %STARTPORT%
IF EXIST Lib\Wait.exe Lib\wait.exe %WAITTIME%
SET /A STARTPORT += 1
SET /A NUMPORTS -= 1
if %NUMPORTS% LSS 0 GOTO END
GOTO LOOP

:WARNEND
ECHO DONE
ECHO Continuing will attempt to clean up all NetCat processes
PAUSE

:KILLNC
ECHO Killing NetCat processes
taskkill /IM nc.exe /T /F

:END
ECHO Done.
PAUSE
EXIT 0