@ECHO off
@REM homemon
@REM monitor the status of the home page
@REM Updated 2008-10-21

IF NOT EXIST Lib\wget.exe ECHO wget.exe not found. Cannot continue & EXIT 1
IF NOT EXIST Lib\sed.exe ECHO sed.exe not found. Cannot continue & EXIT 1

:SETUP
SET CONFDIR=Conf
SET LOGFILE=logfile
SET IPADDY=192.168.2.1
SET RMODEL=NULL
SET TEMPDIR=TEMP
SET TIMEOUT=10
SET RETRY=1

SET /P LOGFILE=Enter in a log name (w/o extension): 
IF EXIST "%LOGFILE%-wget.log" GOTO OVERWRITELOG
:CONTINUE
SET /P IPADDY=Enter in the IP address of the router: 
ECHO ============ ROUTERS =============
DIR /B %CONFDIR% | Lib\sed.exe -e "s/.bat//g"
ECHO ==================================
SET /P RMODEL=Enter the router from the list above: 

:CALLSCRIPT

IF NOT EXIST %CONFDIR%\%RMODEL%.bat ECHO Cannot find configuration for %RMODEL%. Cannot Continue. & EXIT 1
START %CONFDIR%\%RMODEL%.bat

:END
ECHO.
ECHO DONE
PAUSE
EXIT 0

:OVERWRITELOG
SET ANS=n
ECHO ** "%LOGFILE%.log" already exists.  Would you like to overwrite this file?
SET /P ANS=   (y/N): 
IF "%ANS%"=="n" GOTO SETUP
IF "%ANS%"=="N" GOTO SETUP
IF "%ANS%"=="y" DEL "%LOGFILE%.log" & GOTO CONTINUE
IF "%ANS%"=="Y" DEL "%LOGFILE%.log" & GOTO CONTINUE
ECHO    "%ANS%" is not valid
GOTO END