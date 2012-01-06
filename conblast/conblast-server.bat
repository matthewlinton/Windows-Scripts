@ECHO off
@REM conblast-server
@REM Open up a user defined set of persistant connections that will wait for connections
@REM Updated 20078-01-07

IF NOT EXIST Lib\nc.exe ECHO nc.exe not found. unable to continue. & GOTO END

:INFO
ECHO *******************************************************************************
ECHO Some systems have trouble handling the large number of process and open ports
ECHO that this script generates. The Default maximum number of ports allowed has 
ECHO been SET at %MAXPORTS% and should work for most systems.
ECHO *******************************************************************************
pause

:SETUP
SET STARTPORT=1024
SET NUMPORTS=100
SET MAXPORTS=400
SET MINPORT=1024

:CONFIG
SET /P STARTPORT=Enter a starting port (%STARTPORT%): 
SET /P NUMPORTS=Enter in the number of ports to open (%NUMPORTS%): 

IF %NUMPORTS% GTR %MAXPORTS% ECHO ** Cannot open more than %MAXPORTS% ports & GOTO CONFIG
IF %STARTPORT% LSS %MINPORT% ECHO ** Cannot open ports lower than %MINPORT%. & GOTO CONFIG
SET /A ENDPORT=%STARTPORT% + %NUMPORTS%
IF %ENDPORT% GTR 65535 ECHO ** Port range goes beyond maximum of 65535 ports & GOTO CONFIG

:LOOP
ECHO Starting NetCat server on port %STARTPORT%
start Lib\nc.exe -d -L -p %STARTPORT%
SET /A STARTPORT += 1
SET /A NUMPORTS -= 1
IF %NUMPORTS% LSS 0 goto WARNEND
GOTO LOOP

:WARNEND
ECHO DONE
ECHO Continuing will attempt to clean up ALL NetCat processes.
pause

:KILLNC
ECHO Killing NetCat processes.
taskkill /IM nc.exe /T /F

:END
ECHO Done.
pause
exit 0